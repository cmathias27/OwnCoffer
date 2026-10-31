import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../file_pick.dart';

Future<PickedFile?> pickFile(List<String> extensions) {
  final done = Completer<PickedFile?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = extensions.join(',');
  input.addEventListener(
    'change',
    (web.Event _) {
      final file = input.files?.item(0);
      if (file == null) {
        if (!done.isCompleted) done.complete(null);
        return;
      }
      file.arrayBuffer().toDart.then(
        (buffer) {
          if (!done.isCompleted) {
            done.complete(PickedFile(file.name, buffer.toDart.asUint8List()));
          }
        },
        onError: (Object e) {
          if (!done.isCompleted) done.completeError(e);
        },
      );
    }.toJS,
  );
  input.addEventListener(
    'cancel',
    (web.Event _) {
      if (!done.isCompleted) done.complete(null);
    }.toJS,
  );
  input.click();
  return done.future;
}
