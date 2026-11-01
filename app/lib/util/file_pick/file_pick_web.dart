import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../file_pick.dart';

/// The browser decides: on a phone, `capture` opens the camera; elsewhere
/// it falls back to the file dialog.
bool get canUseCamera => true;

Future<PickedFile?> pickFile(List<String> extensions, {bool camera = false}) {
  final done = Completer<PickedFile?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = camera ? 'image/*' : extensions.join(',');
  if (camera) input.setAttribute('capture', 'environment');
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

Future<List<PickedFile>> pickFiles(List<String> extensions) {
  final done = Completer<List<PickedFile>>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..multiple = true
    ..accept = extensions.join(',');
  Future<void> read() async {
    final files = input.files;
    final result = <PickedFile>[];
    try {
      for (var i = 0; i < (files?.length ?? 0); i++) {
        final f = files!.item(i)!;
        final buffer = await f.arrayBuffer().toDart;
        result.add(PickedFile(f.name, buffer.toDart.asUint8List()));
      }
      if (!done.isCompleted) done.complete(result);
    } on Object catch (e) {
      if (!done.isCompleted) done.completeError(e);
    }
  }

  // A JS callback cannot return a Future: the reading runs on its own.
  input.addEventListener(
    'change',
    (web.Event _) {
      read();
    }.toJS,
  );
  input.addEventListener(
    'cancel',
    (web.Event _) {
      if (!done.isCompleted) done.complete(const []);
    }.toJS,
  );
  input.click();
  return done.future;
}
