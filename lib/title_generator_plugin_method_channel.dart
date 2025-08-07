import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'title_generator_plugin_platform_interface.dart';

/// An implementation of [TitleGeneratorPluginPlatform] that uses method channels.
class MethodChannelTitleGeneratorPlugin extends TitleGeneratorPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('title_generator_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<List<String>> generateTitles(String text) async {
    try {
      final List<dynamic> result = await methodChannel.invokeMethod(
        'generateTitles',
        {'text': text},
      );
      return result.cast<String>();
    } on PlatformException catch (e) {
      debugPrint('Platform error generating titles: ${e.message}');
      return ['Error generating titles: ${e.message}'];
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return ['Unexpected error occurred: $e'];
    }
  }
}
