import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:title_generator/title_generator_plugin_method_channel.dart';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelTitleGeneratorPlugin platform = MethodChannelTitleGeneratorPlugin();
  const MethodChannel channel = MethodChannel('title_generator_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
