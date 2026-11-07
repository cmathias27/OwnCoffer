import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/file_pick.dart';
import 'package:owncoffer_app/util/incoming_file.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IncomingFileHandler', () {
    const channel = MethodChannel('org.owncoffer.app/incoming_file_test');

    setUp(() {
      IncomingFileHandler.reset();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('parseFile parses valid map with Uint8List or List<int>', () {
      final f1 = IncomingFileHandler.parseFile({
        'name': 'statement.qif',
        'bytes': Uint8List.fromList([1, 2, 3]),
      });
      expect(f1?.name, 'statement.qif');
      expect(f1?.bytes, [1, 2, 3]);

      final f2 = IncomingFileHandler.parseFile({
        'name': 'releve.ofx',
        'bytes': [4, 5, 6],
      });
      expect(f2?.name, 'releve.ofx');
      expect(f2?.bytes, [4, 5, 6]);

      expect(IncomingFileHandler.parseFile({}), isNull);
      expect(IncomingFileHandler.parseFile({'name': 'test'}), isNull);
    });

    test('retrieves initial file on startup', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'getInitialFile') {
              return {
                'name': 'initial.ofx',
                'bytes': [10, 20, 30],
              };
            }
            return null;
          });

      PickedFile? received;
      final sub = IncomingFileHandler.files.listen((f) => received = f);

      await IncomingFileHandler.init(testChannel: channel);
      await pumpEventQueue();

      expect(received, isNotNull);
      expect(received?.name, 'initial.ofx');
      expect(received?.bytes, [10, 20, 30]);

      await sub.cancel();
    });

    test('delivers onFileReceived while running', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async => null);

      PickedFile? received;
      final sub = IncomingFileHandler.files.listen((f) => received = f);

      await IncomingFileHandler.init(testChannel: channel);

      // Simulate native calling onFileReceived
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      final codec = channel.codec;
      final data = codec.encodeMethodCall(
        const MethodCall('onFileReceived', {
          'name': 'download.qif',
          'bytes': [7, 8, 9],
        }),
      );

      await messenger.handlePlatformMessage(
        channel.name,
        data,
        (ByteData? reply) {},
      );
      await pumpEventQueue();

      expect(received, isNotNull);
      expect(received?.name, 'download.qif');
      expect(received?.bytes, [7, 8, 9]);

      await sub.cancel();
    });
  });
}
