import 'title_generator_plugin_platform_interface.dart';

/// A Flutter plugin for generating smart titles from text using platform-specific NLP capabilities.
/// 
/// This plugin leverages native Natural Language Processing capabilities on iOS and Android
/// to generate contextual and relevant titles from input text.
class TitleGeneratorPlugin {
  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    return TitleGeneratorPluginPlatform.instance.getPlatformVersion();
  }

  /// Generates smart titles from the given text.
  /// 
  /// Uses platform-specific NLP capabilities to analyze the text and generate
  /// relevant, contextual titles. On iOS, it uses NaturalLanguage framework,
  /// and on Android, it uses platform-specific NLP libraries.
  /// 
  /// [text] - The input text to generate titles from
  /// 
  /// Returns a list of generated titles. If generation fails, returns a list
  /// with an error message.
  Future<List<String>> generateTitles(String text) {
    return TitleGeneratorPluginPlatform.instance.generateTitles(text);
  }
}
