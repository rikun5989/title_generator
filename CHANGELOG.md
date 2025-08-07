# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2024-01-XX

### Added
- Initial release of Title Generator Plugin
- Cross-platform support for iOS and Android
- Native NLP integration using iOS NaturalLanguage framework
- Android text processing capabilities
- Simple API for generating smart titles from text
- Platform-specific title generation algorithms
- Error handling with graceful fallbacks
- Example app demonstrating plugin usage

### Features
- `generateTitles(String text)` - Generate smart titles from input text
- `getPlatformVersion()` - Get platform version information
- iOS: Advanced NLP with part-of-speech tagging
- Android: Basic text processing with word filtering

### Technical Details
- Built with Flutter plugin architecture
- Uses platform channels for native code communication
- Supports Flutter 3.3.0 and above
- Compatible with Dart SDK 3.7.2 and above
