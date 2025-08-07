import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'title_generator_plugin_method_channel.dart';

abstract class TitleGeneratorPluginPlatform extends PlatformInterface {
  /// Constructs a TitleGeneratorPluginPlatform.
  TitleGeneratorPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TitleGeneratorPluginPlatform _instance = MethodChannelTitleGeneratorPlugin();

  /// The default instance of [TitleGeneratorPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTitleGeneratorPlugin].
  static TitleGeneratorPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TitleGeneratorPluginPlatform] when
  /// they register themselves.
  static set instance(TitleGeneratorPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Generates smart titles from the given text using platform-specific NLP capabilities.
  /// 
  /// Returns a list of generated titles, or a list with error message if generation fails.
  Future<List<String>> generateTitles(String text) {
    throw UnimplementedError('generateTitles() has not been implemented.');
  }
}
