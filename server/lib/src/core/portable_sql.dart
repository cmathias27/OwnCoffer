import 'package:serverpod/serverpod.dart';

/// The few hand-written SQL queries run on PostgreSQL (server) and on
/// SQLite (standalone app, decision 0022): same SQL text, and values bound
/// the way each database stores them.
extension PortableSql on Session {
  bool get onSqlite => db.dialect == DatabaseDialect.sqlite;

  /// A timestamp as a query parameter: PostgreSQL takes the DateTime, the
  /// SQLite tables keep milliseconds since the epoch (UTC).
  Object sqlTimestamp(DateTime t) =>
      onSqlite ? t.toUtc().millisecondsSinceEpoch : t.toUtc();
}
