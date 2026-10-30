/// OwnCoffer pure Dart core, shared by the server and the app.
///
/// No I/O, no network, no Flutter: everything here is deterministic and
/// covered by unit tests. Amounts are integer cents, dates are [LocalDate].
///
/// Import pipeline: [readStatement] → [checkDuplicates] → [cleanLabel] →
/// [Classifier.classify]. Forecast pipeline: [reconcile] first (so a realised
/// occurrence is not counted twice), then [computeForecast].
library;

export 'src/banks/caisse_epargne.dart';
export 'src/categories.dart';
export 'src/classification/classifier.dart';
export 'src/data/standard_categories.dart';
export 'src/forecast/forecast.dart';
export 'src/forecast/recurrence.dart';
export 'src/import/csv_parser.dart';
export 'src/import/decoding.dart';
export 'src/import/duplicates.dart';
export 'src/import/ofx_parser.dart';
export 'src/import/qif_parser.dart';
export 'src/import/statement.dart';
export 'src/import/statement_reader.dart';
export 'src/labels/label_cleaner.dart';
export 'src/local_date.dart';
export 'src/money.dart';
export 'src/text.dart';
