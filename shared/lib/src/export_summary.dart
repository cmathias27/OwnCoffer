/// What an OwnCoffer export holds, without its ids (decision 0022): the
/// export of a group and the export of its copy on another server give the
/// same summary, so a move can be checked end to end; each difference is
/// named.
///
/// Only figures the user can check: counts of every section, sums of the
/// amounts, and each account's operations.
class ExportSummary {
  /// Label → value, in a stable order.
  final Map<String, String> facts;

  const ExportSummary._(this.facts);

  /// The sections an export carries and the import recreates.
  static const sections = [
    'accounts',
    'categories',
    'rules',
    'goals',
    'scheduledTransactions',
    'transactions',
    'transactionSplits',
    'balanceChecks',
    'imports',
    'loans',
    'loanDocuments',
    'invoices',
    'aiMemories',
    'aiConversations',
  ];

  factory ExportSummary.of(Map<String, dynamic> doc) {
    List<Map<String, dynamic>> rows(String key) => [
      for (final r in (doc[key] as List?) ?? const [])
        Map<String, dynamic>.from(r as Map),
    ];
    int sum(String key, String field) => rows(
      key,
    ).fold(0, (s, r) => s + ((r[field] as num?)?.toInt() ?? 0));
    int count(String key, bool Function(Map<String, dynamic>) test) =>
        rows(key).where(test).length;

    final facts = <String, String>{
      for (final s in sections) '$s.count': '${rows(s).length}',
      'transactions.amount': '${sum('transactions', 'amountCents')}',
      'transactions.categorised':
          '${count('transactions', (r) => r['categoryId'] != null)}',
      'transactions.transfers':
          '${count('transactions', (r) => r['transferPairId'] != null)}',
      'transactions.planned':
          '${count('transactions', (r) => r['scheduledId'] != null)}',
      'transactionSplits.amount': '${sum('transactionSplits', 'amountCents')}',
      'scheduledTransactions.amount':
          '${sum('scheduledTransactions', 'amountCents')}',
      'goals.amount': '${sum('goals', 'amountCents')}',
      'loans.principal': '${sum('loans', 'principalCents')}',
      'invoices.bytes': '${sum('invoices', 'sizeBytes')}',
      'invoices.linked':
          '${count('invoices', (r) => r['transactionId'] != null)}',
      'loanDocuments.bytes': '${sum('loanDocuments', 'sizeBytes')}',
      'categories.children':
          '${count('categories', (r) => r['parentId'] != null)}',
    };

    // Each account by what the user sees of it: name, kind, initial
    // balance, then its operations' count and total (its balance).
    final ops = <Object?, ({int n, int cents})>{};
    for (final t in rows('transactions')) {
      final o = ops[t['accountId']] ?? (n: 0, cents: 0);
      ops[t['accountId']] = (
        n: o.n + 1,
        cents: o.cents + ((t['amountCents'] as num?)?.toInt() ?? 0),
      );
    }
    final accounts =
        [
          for (final a in rows('accounts'))
            (
              name: '${a['name']} (${a['kind']})',
              value:
                  '${(a['initialBalanceCents'] as num?)?.toInt() ?? 0}'
                  ' + ${ops[a['id']]?.n ?? 0} op. '
                  '= ${(ops[a['id']]?.cents ?? 0)}',
            ),
        ]..sort((a, b) {
          final n = a.name.compareTo(b.name);
          return n != 0 ? n : a.value.compareTo(b.value);
        });
    final seen = <String, int>{};
    for (final a in accounts) {
      final i = seen[a.name] = (seen[a.name] ?? 0) + 1;
      facts['account ${a.name}${i > 1 ? ' #$i' : ''}'] = a.value;
    }
    return ExportSummary._(facts);
  }

  /// What differs from [other], one line per fact: `label: mine ≠ theirs`
  /// (`—` when a fact is missing on one side). Empty when they agree.
  List<String> differences(ExportSummary other) => [
    for (final k in {...facts.keys, ...other.facts.keys})
      if (facts[k] != other.facts[k])
        '$k: ${facts[k] ?? '—'} ≠ ${other.facts[k] ?? '—'}',
  ];
}
