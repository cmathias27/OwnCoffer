import 'dart:convert';
import 'dart:math' as math;

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../endpoints/loan_endpoint.dart';
import '../finance/loan_terms.dart';
import '../finance/proposal_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import 'ai_gateway.dart';

/// Documents read by the AI (décisions 0008 and 0009): the model reports
/// what a receipt, an invoice or a loan document says; the engine checks
/// it, does every sum, and turns it into proposals that the user accepts or
/// not in "Mon conseiller". Nothing is changed here.
abstract final class DocumentReader {
  static const _maxLines = 100;
  static const _maxParts = 20;

  static Map<String, Object?> _tool(
    String name,
    String description,
    Map<String, Object?> properties,
  ) => {
    'type': 'function',
    'function': {
      'name': name,
      'description': description,
      'parameters': {'type': 'object', 'properties': properties},
    },
  };

  static int? _cents(Object? v) {
    final n = (v as num?)?.toInt();
    return n == null || n <= 0 || n > core.maxLoanPrincipalCents ? null : n;
  }

  static String? _text(Object? v, [int max = 80]) {
    final s = (v is String ? v : '').trim().replaceAll(RegExp(r'\s+'), ' ');
    if (s.isEmpty) return null;
    return s.length > max ? s.substring(0, max) : s;
  }

  static DateTime? _day(Object? v) {
    final d = v is String ? DateTime.tryParse(v) : null;
    return d == null ? null : DateTime.utc(d.year, d.month, d.day);
  }

  static String _iso(DateTime d) => d.toIso8601String().substring(0, 10);

  static Future<List<int>> _invoiceBytes(Session session, int invoiceId) async {
    final blob = await InvoiceBlob.db.findFirstRow(
      session,
      where: (b) => b.invoiceId.equals(invoiceId),
    );
    if (blob == null) {
      throw AccessDeniedException(code: 'invoice_access_denied');
    }
    return blob.content.buffer.asUint8List(
      blob.content.offsetInBytes,
      blob.content.lengthInBytes,
    );
  }

  /// A receipt or invoice: joined to an operation, its lines become a
  /// proposed split of the operation; waiting for its operation, its
  /// amount, date and merchant are proposed.
  static Future<AiReply> readInvoice(
    Session session,
    int invoiceId, {
    List<String>? pageImagesBase64,
  }) async {
    final invoice = await Invoice.db.findById(session, invoiceId);
    if (invoice == null) {
      throw AccessDeniedException(code: 'invoice_access_denied');
    }
    if (invoice.transactionId == null) {
      await Access.requireMember(
        session,
        invoice.groupId,
        min: MemberRole.user,
      );
      return _readHints(session, invoice, pageImagesBase64: pageImagesBase64);
    }
    final t = await BankTransaction.db.findById(
      session,
      invoice.transactionId!,
    );
    if (t == null || t.deletedAt != null) {
      throw AccessDeniedException(code: 'invoice_access_denied');
    }
    try {
      await Access.requireAccount(session, t.accountId, write: true);
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'invoice_access_denied');
    }
    return _readReceipt(
      session,
      invoice,
      t,
      pageImagesBase64: pageImagesBase64,
    );
  }

  static Future<AiReply> _readReceipt(
    Session session,
    Invoice invoice,
    BankTransaction t, {
    List<String>? pageImagesBase64,
  }) async {
    final groupId = invoice.groupId;
    final categories = await Category.db.find(
      session,
      where: (c) =>
          c.groupId.equals(groupId) &
          c.deletedAt.equals(null) &
          c.kind.equals(
            t.amountCents < 0 ? CategoryKind.expense : CategoryKind.income,
          ),
      orderBy: (c) => c.id,
    );
    final allowed = {for (final c in categories) c.id!};
    final read = await AiGateway.readDocument(
      session,
      groupId,
      feature: AiFunctions.invoice,
      bytes: pageImagesBase64 == null
          ? await _invoiceBytes(session, invoice.id!)
          : null,
      mimeType: pageImagesBase64 == null ? invoice.mimeType : null,
      pageImagesBase64: pageImagesBase64,
      instructions:
          'This is a receipt or an invoice. Report its merchant, date, total '
          'and each line with its amount (positive, in cents) and, if one '
          'fits, the id of its category among: '
          '${[for (final c in categories) '${c.id}: ${c.name ?? c.standardCode}'].join('; ')}.',
      tool: _tool('receipt_lines', 'What the receipt says.', {
        'merchant': {'type': 'string'},
        'date': {'type': 'string', 'description': 'YYYY-MM-DD.'},
        'total_cents': {'type': 'integer'},
        'lines': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'label': {'type': 'string'},
              'amount_cents': {'type': 'integer'},
              'category_id': {'type': 'integer'},
            },
          },
        },
      }),
    );
    final f = read.fields;
    final lines = [
      for (final x in ((f['lines'] as List?) ?? const []).take(_maxLines))
        if (x is Map && _cents(x['amount_cents']) != null)
          (
            label: _text(x['label']) ?? '',
            cents: _cents(x['amount_cents'])!,
            category: allowed.contains((x['category_id'] as num?)?.toInt())
                ? (x['category_id'] as num).toInt()
                : null,
          ),
    ];
    if (lines.isEmpty) {
      throw InvalidInputException(code: 'document_nothing_read');
    }
    // The engine's sums: by category, then what the lines leave (discount,
    // rounding, a line not read) as a part to classify.
    final abs = t.amountCents.abs();
    final readCents = lines.fold(0, (a, l) => a + l.cents);
    if (readCents > abs) {
      throw InvalidInputException(code: 'receipt_mismatch');
    }
    final byCategory = <int?, ({int cents, List<String> labels})>{};
    for (final l in lines) {
      final c = byCategory[l.category];
      byCategory[l.category] = (
        cents: (c?.cents ?? 0) + l.cents,
        labels: [...?c?.labels, if (l.label.isNotEmpty) l.label],
      );
    }
    final rest = abs - readCents;
    if (rest > 0) {
      // With the lines without a category: one part to classify.
      final c = byCategory[null];
      byCategory[null] = (
        cents: (c?.cents ?? 0) + rest,
        labels: [...?c?.labels],
      );
    }
    final sign = t.amountCents < 0 ? -1 : 1;
    final parts = [
      for (final e in byCategory.entries)
        {
          'category_id': e.key,
          'amount_cents': sign * e.value.cents,
          'note': _text(e.value.labels.take(4).join(', '), 200),
        },
    ];
    if (parts.length > _maxParts) {
      throw InvalidInputException(code: 'split_invalid');
    }
    final splits = await TransactionSplit.db.find(
      session,
      where: (s) => s.transactionId.equals(t.id!),
      orderBy: (s) => s.id,
    );
    final data = {
      'label': t.cleanLabel,
      'amount_cents': t.amountCents,
      'date': _iso(t.date),
      'merchant': _text(f['merchant']),
      'total_cents': _cents(f['total_cents']),
      'lines': [
        for (final l in lines.take(30))
          {
            'label': l.label,
            'amount_cents': l.cents,
            'category_id': l.category,
          },
      ],
      'rest_cents': rest,
      'document': invoice.fileName,
      'before': {
        'category_id': t.categoryId,
        'source': t.categorySource.name,
        'rule_ref': t.categoryRuleRef,
        'splits': [
          for (final s in splits)
            {
              'category_id': s.categoryId,
              'amount_cents': s.amountCents,
              'note': s.note,
            },
        ],
      },
    };
    final ActionProposal? p;
    if (parts.length >= 2) {
      p = await ProposalService.propose(
        session,
        groupId: groupId,
        kind: 'set_split',
        targetId: t.id!,
        currentValue: t.categoryId,
        proposedValue: null,
        proposedData: jsonEncode({'parts': parts}),
        reason: 'ai_receipt_split',
        data: data,
        origin: 'ai',
        provider: read.provider.name,
        model: read.model,
      );
    } else if (parts.single['category_id'] != null) {
      // One category for the whole receipt: no split, a category.
      p = await ProposalService.propose(
        session,
        groupId: groupId,
        kind: 'set_category',
        targetId: t.id!,
        currentValue: t.categoryId,
        proposedValue: parts.single['category_id'] as int,
        reason: 'ai_category',
        data: {
          ...data,
          'why': _text(f['merchant']) ?? invoice.fileName,
        },
        origin: 'ai',
        provider: read.provider.name,
        model: read.model,
      );
    } else {
      throw InvalidInputException(code: 'document_nothing_read');
    }
    return _reply(read.provider, read.model, [?p]);
  }

  static Future<AiReply> _readHints(
    Session session,
    Invoice invoice, {
    List<String>? pageImagesBase64,
  }) async {
    final read = await AiGateway.readDocument(
      session,
      invoice.groupId,
      feature: AiFunctions.invoice,
      bytes: pageImagesBase64 == null
          ? await _invoiceBytes(session, invoice.id!)
          : null,
      mimeType: pageImagesBase64 == null ? invoice.mimeType : null,
      pageImagesBase64: pageImagesBase64,
      instructions:
          'This is an invoice or a receipt. Report the total paid, the date '
          'of the purchase and the merchant.',
      tool: _tool('invoice_fields', 'What the invoice says.', {
        'amount_cents': {'type': 'integer'},
        'date': {'type': 'string', 'description': 'YYYY-MM-DD.'},
        'merchant': {'type': 'string'},
      }),
    );
    final f = read.fields;
    final date = _day(f['date']);
    final fields = {
      'amount_cents': _cents(f['amount_cents']) ?? invoice.hintAmountCents,
      'date': date == null
          ? invoice.hintDate?.toIso8601String().substring(0, 10)
          : _iso(date),
      'merchant': _text(f['merchant']) ?? invoice.hintMerchant,
    };
    final before = ProposalService.invoiceHints(invoice);
    if (jsonEncode(fields) == jsonEncode(before)) {
      return _reply(read.provider, read.model, const []);
    }
    final p = await ProposalService.propose(
      session,
      groupId: invoice.groupId,
      kind: 'set_invoice_hints',
      targetId: invoice.id!,
      currentValue: null,
      proposedValue: null,
      proposedData: jsonEncode(fields),
      reason: 'ai_invoice_hints',
      data: {...fields, 'document': invoice.fileName, 'before': before},
      origin: 'ai',
      provider: read.provider.name,
      model: read.model,
    );
    return _reply(read.provider, read.model, [?p]);
  }

  /// A loan document (amortisation table, offer): the terms it states are
  /// proposed for the loan, checked by the loan engine first.
  static Future<AiReply> readLoanDocument(
    Session session,
    int documentId, {
    List<String>? pageImagesBase64,
  }) async {
    final doc = await LoanDocument.db.findById(session, documentId);
    final loan = doc == null
        ? null
        : await Loan.db.findById(session, doc.loanId);
    if (doc == null || loan == null || loan.deletedAt != null) {
      throw AccessDeniedException(code: 'loan_access_denied');
    }
    try {
      await Access.requireMember(session, loan.groupId, min: MemberRole.user);
      if (loan.accountId != null) {
        await Access.requireAccount(session, loan.accountId!, write: true);
      }
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'loan_access_denied');
    }
    final blob = pageImagesBase64 == null
        ? await LoanDocumentBlob.db.findFirstRow(
            session,
            where: (b) => b.documentId.equals(doc.id!),
          )
        : null;
    if (pageImagesBase64 == null && blob == null) {
      throw AccessDeniedException(code: 'loan_access_denied');
    }
    final read = await AiGateway.readDocument(
      session,
      loan.groupId,
      feature: AiFunctions.loan,
      bytes: blob?.content.buffer.asUint8List(
        blob.content.offsetInBytes,
        blob.content.lengthInBytes,
      ),
      mimeType: blob == null ? null : doc.mimeType,
      pageImagesBase64: pageImagesBase64,
      instructions:
          'This is a document of a loan (amortisation table, loan offer, '
          'screenshot of the bank). Report the terms it states: capital '
          'borrowed, nominal annual rate in thousandths of a percent '
          '(3.45 % = 3450), duration in months, monthly instalment without '
          'insurance, monthly insurance, first due date. If the document has an '
          'amortisation table, report EVERY row as printed, on every page, '
          'without skipping or summarising any: instalment number, payment '
          'without insurance (0 when nothing is paid), interest, capital '
          'still owed after it, all in cents. Copy the figures, never compute '
          'them: rows where the rate changes or instalments are paused are '
          'found from them. Also report the total interest. If a loan offer '
          'states the early repayment penalty (indemnité de remboursement '
          'anticipé), report it as written: months of interest on the amount '
          'repaid, and/or a percentage of it in thousandths of a percent '
          '(3 % = 3000); 0 when it says there is none.',
      tool: _tool('loan_terms', 'The terms the document states.', {
        'principal_cents': {'type': 'integer'},
        'annual_rate_milli': {'type': 'integer'},
        'duration_months': {'type': 'integer'},
        'payment_cents': {'type': 'integer'},
        'insurance_monthly_cents': {'type': 'integer'},
        'first_due_date': {'type': 'string', 'description': 'YYYY-MM-DD.'},
        'disbursement_date': {
          'type': 'string',
          'description':
              'Disbursement day (YYYY-MM-DD) when not 1 month before first instalment.',
        },
        'first_interest_cents': {
          'type': 'integer',
          'description':
              'Intercalary or initial interest of the first instalment.',
        },
        'total_interest_cents': {'type': 'integer'},
        'prepayment_interest_months': {
          'type': 'integer',
          'description':
              'Early repayment penalty: months of interest on the amount '
              'repaid.',
        },
        'prepayment_percent_milli': {
          'type': 'integer',
          'description':
              'Early repayment penalty: thousandths of a percent of the '
              'amount repaid.',
        },
        'schedule': {
          'type': 'array',
          'description': 'Every row of the amortisation table, in order.',
          'items': {
            'type': 'object',
            'properties': {
              'number': {'type': 'integer'},
              'payment_cents': {'type': 'integer'},
              'interest_cents': {'type': 'integer'},
              'remaining_cents': {'type': 'integer'},
            },
          },
        },
      }),
    );
    final f = read.fields;
    int? n(String k, int max) {
      final v = (f[k] as num?)?.toInt();
      return v == null || v < 0 || v > max ? null : v;
    }

    final eventsBefore = [
      for (final e in loan.events ?? const <LoanEvent>[])
        ProposalService.loanEventJson(e),
    ];
    // With the changes, even none: undoing puts them back as they were.
    final before = {
      ...ProposalService.loanFields(loan),
      'events': eventsBefore,
      'prepayment_interest_months': loan.prepaymentInterestMonths,
      'prepayment_percent_milli': loan.prepaymentPercentMilli,
    };
    // No penalty on a revolving credit or a payment in instalments.
    final penalty =
        LoanEndpoint.prepaymentLaw(loan.kind) != core.PrepaymentLaw.none;
    final first = _day(f['first_due_date']);
    final disb = _day(f['disbursement_date']);
    final readFields = <String, Object?>{
      'principal_cents': ?_cents(f['principal_cents']),
      'annual_rate_milli': ?n('annual_rate_milli', core.maxLoanRateMilli),
      'duration_months': ?n('duration_months', core.maxLoanMonths),
      'payment_cents': ?_cents(f['payment_cents']),
      'insurance_monthly_cents': ?n(
        'insurance_monthly_cents',
        core.maxLoanPrincipalCents,
      ),
      if (first != null) 'first_due_date': _iso(first),
      if (disb != null) 'disbursement_date': _iso(disb),
      'first_interest_cents': ?_cents(f['first_interest_cents']),
      if (penalty)
        'prepayment_interest_months': ?n(
          'prepayment_interest_months',
          core.maxPrepaymentInterestMonths,
        ),
      if (penalty)
        'prepayment_percent_milli': ?n(
          'prepayment_percent_milli',
          core.maxPrepaymentPercentMilli,
        ),
    };
    final rows = _tableRows(f);
    if (readFields.isEmpty && rows.isEmpty) {
      throw InvalidInputException(code: 'document_nothing_read');
    }
    final changed = {
      for (final e in readFields.entries)
        if (before[e.key] != e.value) e.key: e.value,
    };
    // The loan engine must accept the terms as they would be.
    core.LoanTerms termsOf(Map<String, Object?> m) {
      try {
        return core.LoanTerms(
          principalCents: m['principal_cents']! as int,
          annualRateMilli: m['annual_rate_milli']! as int,
          months: m['duration_months']! as int,
          // `_day` gives UTC midnight whatever the server's time zone is.
          firstDue: _day(m['first_due_date'])!.toLocalDate(),
          insuranceMonthlyCents: m['insurance_monthly_cents']! as int,
          paymentCents: m['payment_cents'] as int?,
          disbursementDate: _day(m['disbursement_date'])?.toLocalDate(),
          firstInterestCents: m['first_interest_cents'] as int?,
        );
      } on ArgumentError {
        throw InvalidInputException(code: 'loan_terms_invalid');
      }
    }

    var terms = termsOf({...before, ...changed});
    // The whole table, read by the loan engine (decision 0042): what changed
    // the loan (rate, instalment, pause, money repaid) and the rows it does
    // not explain.
    var finalEvents = loan.events ?? const <LoanEvent>[];
    core.LoanTableReading? table;
    if (rows.isNotEmpty) {
      final from = terms.firstDue.addMonths(
        rows.map((r) => r.number).reduce(math.min) - 1,
      );
      final to = terms.firstDue.addMonths(
        rows.map((r) => r.number).reduce(math.max) - 1,
      );
      // Changes the table cannot show: before its first row or after its
      // last one. Those in between are what the table says.
      final earlier = [
        for (final e in finalEvents)
          if (e.date.toLocalDate() <= from.addMonths(-1)) e,
      ];
      final later = [
        for (final e in finalEvents)
          if (e.date.toLocalDate() > to) e,
      ];
      table = core.readLoanTable(
        terms,
        rows,
        known: LoanTermsOf.changes(loan.copyWith(events: earlier)),
      );
      final interest = table.firstInterestCents;
      if (interest != null &&
          !readFields.containsKey('first_interest_cents') &&
          before['first_interest_cents'] != interest) {
        changed['first_interest_cents'] = interest;
        terms = termsOf({...before, ...changed});
      }
      if (table.changes.isNotEmpty) {
        final found = [
          ...earlier,
          for (final c in table.changes)
            LoanEvent(
              date: c.date.toDb(),
              annualRateMilli: c.annualRateMilli,
              paymentCents: c.paymentCents,
              remainingMonths: c.remainingMonths,
              drawCents: c.drawCents == 0 ? null : c.drawCents,
              pauseMonths: c.pauseMonths,
              pauseCapitalized: c.pauseMonths == null
                  ? null
                  : c.pauseCapitalized,
            ),
          ...later,
        ]..sort((a, b) => a.date.compareTo(b.date));
        // Kept only when the loan engine accepts them: the loan is repaid.
        final schedule = _scheduleOf(terms, loan, found);
        if (schedule != null && found.length <= _maxLoanEvents) {
          final json = [
            for (final e in found) ProposalService.loanEventJson(e),
          ];
          if (jsonEncode(json) != jsonEncode(eventsBefore)) {
            changed['events'] = json;
            finalEvents = found;
          }
        }
      }
    }
    if (changed.isEmpty) return _reply(read.provider, read.model, const []);
    final check = _checkTable(
      table,
      _scheduleOf(terms, loan, finalEvents) ?? core.amortize(terms),
      f,
      eventsFound: changed.containsKey('events') ? table!.changes.length : 0,
    );
    final p = await ProposalService.propose(
      session,
      groupId: loan.groupId,
      kind: 'update_loan',
      targetId: loan.id!,
      currentValue: null,
      proposedValue: null,
      proposedData: jsonEncode(changed),
      reason: 'ai_loan_terms',
      data: {
        'lender': loan.lender,
        'label': loan.label,
        'document': doc.fileName,
        'changed': changed,
        'before': before,
        'check': ?check,
      },
      origin: 'ai',
      provider: read.provider.name,
      model: read.model,
    );
    return _reply(read.provider, read.model, [?p]);
  }

  /// As LoanEndpoint: most changes kept on a loan.
  static const _maxLoanEvents = 50;

  /// The schedule of [terms] with [events], null when the loan engine
  /// refuses them or the loan would never be repaid.
  static List<core.Installment>? _scheduleOf(
    core.LoanTerms terms,
    Loan loan,
    List<LoanEvent> events,
  ) {
    try {
      final s = core.amortize(
        terms,
        changes: LoanTermsOf.changes(loan.copyWith(events: events)),
      );
      return s.isEmpty || s.length >= core.maxLoanMonths ? null : s;
    } on ArgumentError {
      return null;
    }
  }

  /// The rows of the table the model read, as the loan engine takes them.
  static List<core.LoanTableRow> _tableRows(Map<String, Object?> f) => [
    for (final x in ((f['schedule'] as List?) ?? const []).take(
      core.maxLoanMonths,
    ))
      if (x is Map && x['number'] is num)
        core.LoanTableRow(
          number: (x['number'] as num).toInt(),
          paymentCents: (x['payment_cents'] as num?)?.toInt(),
          interestCents: (x['interest_cents'] as num?)?.toInt(),
          remainingCents: (x['remaining_cents'] as num?)?.toInt(),
        ),
  ];

  /// Largest gap, in cents, between a figure of the document and the same
  /// figure computed by the engine that is not reported (banks round
  /// differently).
  static const scheduleToleranceCents = core.loanTableToleranceCents;

  /// What the engine found comparing the table with the schedule it
  /// computes, for the proposal (decision 0007: every figure shown comes
  /// from the engine). Null when the document has no table and no total.
  static Map<String, Object?>? _checkTable(
    core.LoanTableReading? table,
    List<core.Installment> schedule,
    Map<String, Object?> f, {
    required int eventsFound,
  }) {
    final readInterest = (f['total_interest_cents'] as num?)?.toInt();
    int? totalGap;
    final computedInterest = schedule.fold(0, (a, i) => a + i.interestCents);
    if (readInterest != null &&
        readInterest >= 0 &&
        readInterest <= core.maxLoanPrincipalCents) {
      final gap = (readInterest - computedInterest).abs();
      totalGap = gap > scheduleToleranceCents + computedInterest ~/ 200
          ? gap
          : 0;
    }
    final compared = table?.rowsCompared ?? 0;
    if (compared == 0 && totalGap == null) return null;
    return {
      'rows_compared': compared,
      if (compared > 0) ...{
        'first_number': table!.firstNumber,
        'last_number': table.lastNumber,
        'gap_count': table.gapCount,
        'events_found': eventsFound,
      },
      'mismatches': [
        for (final g in table?.gaps ?? const <core.LoanTableGap>[])
          {
            'number': g.number,
            'field': switch (g.field) {
              'payment' => 'payment_cents',
              'interest' => 'interest_cents',
              'remaining' => 'remaining_cents',
              _ => g.field,
            },
            'read': ?g.readCents,
            'computed': ?g.computedCents,
          },
      ],
      if (totalGap != null) ...{
        'total_interest_read': readInterest,
        'total_interest_computed': computedInterest,
        'total_interest_differs': totalGap > 0,
      },
    };
  }

  static AiReply _reply(
    AiProvider provider,
    String model,
    List<ActionProposal> proposals,
  ) => AiReply(
    text: '',
    tools: const [],
    provider: provider.name,
    model: model,
    isExternal: AiGateway.isExternal(provider.baseUrl),
    proposals: proposals,
  );
}
