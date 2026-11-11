import 'package:http/http.dart' as http;

import '../offline.dart';

/// The web app keeps no financial data (decision 0011).
Future<OfflineStore?> openOfflineStore() async => null;

Future<void> clearOfflineStore() async {}

bool isUnreachable(Object error) => error is http.ClientException;
