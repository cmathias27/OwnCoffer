import 'package:http/http.dart' as http;

import '../offline.dart';
import '../outbox.dart';

/// The web app keeps no financial data (decision 0011).
Future<OfflineStore?> openOfflineStore() async => null;

Future<OutboxStore?> openOutboxStore() async => null;

Future<void> clearOfflineStore({required bool outbox}) async {}

bool isUnreachable(Object error) => error is http.ClientException;
