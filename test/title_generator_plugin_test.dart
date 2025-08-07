import 'package:flutter_test/flutter_test.dart';
import 'package:title_generator/title_generator_plugin.dart';
import 'package:title_generator/title_generator_plugin_method_channel.dart';
import 'package:title_generator/title_generator_plugin_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTitleGeneratorPluginPlatform
    with MockPlatformInterfaceMixin
    implements TitleGeneratorPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<String>> generateTitles(String text) => Future.value(['Mock Title 1', 'Mock Title 2']);
}

void main() {
  final TitleGeneratorPluginPlatform initialPlatform = TitleGeneratorPluginPlatform.instance;

  test('$MethodChannelTitleGeneratorPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTitleGeneratorPlugin>());
  });

  test('getPlatformVersion', () async {
    TitleGeneratorPlugin titleGeneratorPlugin = TitleGeneratorPlugin();
    MockTitleGeneratorPluginPlatform fakePlatform = MockTitleGeneratorPluginPlatform();
    TitleGeneratorPluginPlatform.instance = fakePlatform;

    expect(await titleGeneratorPlugin.getPlatformVersion(), '42');
  });

  test('generateTitles', () async {
    TitleGeneratorPlugin titleGeneratorPlugin = TitleGeneratorPlugin();
    MockTitleGeneratorPluginPlatform fakePlatform = MockTitleGeneratorPluginPlatform();
    TitleGeneratorPluginPlatform.instance = fakePlatform;

    final titles = await titleGeneratorPlugin.generateTitles('Sample text');
    expect(titles, ['Mock Title 1', 'Mock Title 2']);
  });
}
