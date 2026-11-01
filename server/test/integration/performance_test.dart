import 'dart:convert';

import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Roadbook phase 5: OwnCoffer stays fast with 100 000 operations (about
/// eight years of a busy household). The limits are generous, for slow CI
/// machines; the times are printed to follow them from one version to the
/// next. Fictitious data only.
void main() {
  const total = 100000;

  withServerpod(
    'Performance with $total operations',
    // The operations are inserted once for all the measures.
    rollbackDatabase: RollbackDatabase.afterAll,
    (sessionBuilder, endpoints) {
      late Session db;
      late UuidValue alice;
      late int groupId;
      late Account checking;
      late int categoryId;
      final today = DateTime.utc(2026, 11, 2);

      TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          u.toString(),
          {accessScope},
        ),
      );

      /// Runs [call], prints its time, and checks it stays under [limit].
      Future<T> timed<T>(
        String what,
        Duration limit,
        Future<T> Function() call,
      ) async {
        final watch = Stopwatch()..start();
        final result = await call();
        watch.stop();
        // ignore: avoid_print
        print('[perf] $what: ${watch.elapsedMilliseconds} ms');
        expect(
          watch.elapsed,
          lessThan(limit),
          reason: '$what took ${watch.elapsedMilliseconds} ms',
        );
        return result;
      }

      setUpAll(() async {
        db = sessionBuilder.build();
        alice = (await AuthUser.db.insertRow(
          db,
          AuthUser(
            createdAt: DateTime.now(),
            scopeNames: {'owncoffer.serverAdmin'},
            blocked: false,
          ),
        )).id!;
        await UserProfile.db.insertRow(
          db,
          UserProfile(authUserId: alice, email: 'alice@example.org'),
        );
        groupId = (await endpoints.group.create(as(alice), 'Perf')).group.id!;
        checking = await endpoints.account.create(
          as(alice),
          groupId,
          'Courant',
          AccountKind.checking,
        );
        final savings = await endpoints.account.create(
          as(alice),
          groupId,
          'Livret',
          AccountKind.savings,
        );
        final categories = await endpoints.category.list(as(alice), groupId);
        categoryId = categories.firstWhere((c) => c.parentId != null).id!;
        final Set<int> categoryIds = {
          for (final c in categories)
            if (c.parentId != null) c.id!,
        };
        final ids = categoryIds.toList()..sort();
        await endpoints.scheduled.create(
          as(alice),
          checking.id!,
          -80000,
          'LOYER',
          ScheduleFrequency.monthly,
          DateTime.utc(2019, 1, 5),
        );
        // 90 % on the checking account, 10 % on the savings, over 8 years up
        // to today; one category in four, the rest to classify. Plain SQL
        // that runs on PostgreSQL and on SQLite (decision 0022): only the
        // date differs (a timestamp, or milliseconds since the epoch).
        final sqlite = db.db.dialect == DatabaseDialect.sqlite;
        final daysBack = '(s.i * 2922 / $total)';
        final date = sqlite
            ? '(${today.millisecondsSinceEpoch} - $daysBack * 86400000)'
            : "(TIMESTAMP '2026-11-02' - $daysBack * INTERVAL '1 day')";
        final category = [
          'CASE s.i % ${ids.length}',
          for (var k = 0; k < ids.length; k++) 'WHEN $k THEN ${ids[k]}',
          'END',
        ].join(' ');
        await db.db.unsafeExecute('''
        WITH RECURSIVE s(i) AS (
          SELECT 1 UNION ALL SELECT i + 1 FROM s WHERE i < $total
        )
        INSERT INTO "transactions"
          ("accountId", "date", "amountCents", "rawLabel", "cleanLabel",
           "operationKind", "categoryId", "categorySource", "fingerprint",
           "cleared")
        SELECT
          CASE WHEN s.i % 10 = 0 THEN ${savings.id} ELSE ${checking.id} END,
          $date,
          CASE WHEN s.i % 25 = 0 THEN 180000
            ELSE -((s.i * 7919) % 15000) - 100 END,
          'CB MAGASIN ' || (s.i % 400) || ' FACT ' || s.i,
          'MAGASIN ' || (s.i % 400),
          'card',
          CASE WHEN s.i % 4 = 0 THEN $category ELSE NULL END,
          CASE WHEN s.i % 4 = 0 THEN 'groupRule' ELSE 'none' END,
          'perf-' || s.i,
          s.i > 300
        FROM s
      ''');
        await db.db.unsafeExecute('ANALYZE "transactions"');
      });

      test('the data is there', () async {
        expect(await BankTransaction.db.count(db), total);
      });

      test('operations: first page, search, category, to classify', () async {
        const fast = Duration(seconds: 2);
        final page = await timed(
          'operations, first page',
          fast,
          () => endpoints.transaction.list(as(alice), checking.id!, limit: 100),
        );
        expect(page.total, total * 9 ~/ 10);
        expect(page.items.length, 100);
        await timed(
          'operations, page 500',
          fast,
          () => endpoints.transaction.list(
            as(alice),
            checking.id!,
            limit: 100,
            offset: 50000,
          ),
        );
        final search = await timed(
          'operations, search',
          fast,
          () => endpoints.transaction.list(
            as(alice),
            checking.id!,
            search: 'magasin 12',
          ),
        );
        expect(search.total, greaterThan(0));
        await timed(
          'operations, one category',
          fast,
          () => endpoints.transaction.list(
            as(alice),
            checking.id!,
            categoryId: categoryId,
          ),
        );
        await timed(
          'operations, to classify',
          fast,
          () => endpoints.transaction.list(
            as(alice),
            checking.id!,
            toClassify: true,
          ),
        );
        await timed(
          'operations, same provider (with sum)',
          fast,
          () => endpoints.transaction.list(
            as(alice),
            checking.id!,
            sameLabel: 'MAGASIN 7',
          ),
        );
      });

      test('forecast, budget, analyses, calendar, subscriptions', () async {
        const limit = Duration(seconds: 4);
        final f = await timed(
          'forecast 30 days',
          limit,
          () => endpoints.scheduled.forecast(as(alice), checking.id!, today),
        );
        expect(f.days, isNotEmpty);
        await timed(
          'forecast with variable spending',
          limit,
          () => endpoints.scheduled.forecast(
            as(alice),
            checking.id!,
            today,
            includeVariable: true,
          ),
        );
        await timed(
          'budget, 12 months',
          limit,
          () => endpoints.analysis.report(
            as(alice),
            groupId,
            BudgetPeriod.month,
            today,
            periods: 12,
          ),
        );
        await timed(
          'left to live',
          limit,
          () => endpoints.analysis.leftToLive(as(alice), groupId),
        );
        await timed(
          'insights',
          limit,
          () => endpoints.analysis.insights(as(alice), groupId),
        );
        await timed(
          'month review',
          limit,
          () => endpoints.analysis.review(as(alice), groupId, today),
        );
        await timed(
          'calendar',
          limit,
          () => endpoints.scheduled.calendar(as(alice), groupId, today),
        );
        await timed(
          'subscriptions',
          limit,
          () => endpoints.scheduled.subscriptions(as(alice), groupId),
        );
      });

      test('export of everything', () async {
        const limit = Duration(seconds: 30);
        final json = await timed(
          'export JSON',
          limit,
          () => endpoints.export.groupJson(as(alice), groupId),
        );
        final doc = jsonDecode(json) as Map<String, dynamic>;
        expect((doc['transactions'] as List).length, total);
        final csv = await timed(
          'export CSV',
          limit,
          () => endpoints.export.transactionsCsv(as(alice), groupId, 'fr'),
        );
        expect('\r\n'.allMatches(csv).length, total + 1);
      });
    },
  );
}
