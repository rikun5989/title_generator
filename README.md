# Title Generator Plugin

[![pub package](https://img.shields.io/pub/v/title_generator.svg)](https://pub.dev/packages/title_generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.3.0+-blue.svg)](https://flutter.dev)

A Flutter plugin for generating smart titles from text using platform-specific Natural Language Processing capabilities.

## Features

- **Cross-platform support**: Works on both iOS and Android
- **Native NLP**: Uses iOS NaturalLanguage framework and Android text processing
- **Smart title generation**: Analyzes text content to generate contextual titles
- **Easy integration**: Simple API for generating titles from any text input
- **Error handling**: Graceful error handling with informative messages
- **Platform optimization**: Platform-specific algorithms for best results

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  title_generator: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## Quick Start

```dart
import 'package:title_generator/title_generator.dart';

// Create an instance of the plugin
final titleGenerator = TitleGeneratorPlugin();

// Generate titles from text
List<String> titles = await titleGenerator.generateTitles("Your text content here");
print(titles); // ['Generated Title 1', 'Generated Title 2', ...]
```

## Usage

### Basic Usage

```dart
import 'package:title_generator/title_generator.dart';

class TitleGeneratorService {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();

  Future<List<String>> generateTitles(String text) async {
    try {
      return await _titleGenerator.generateTitles(text);
    } catch (e) {
      print('Error generating titles: $e');
      return [];
    }
  }
}
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:title_generator/title_generator.dart';

class TitleGeneratorDemo extends StatefulWidget {
  @override
  _TitleGeneratorDemoState createState() => _TitleGeneratorDemoState();
}

class _TitleGeneratorDemoState extends State<TitleGeneratorDemo> {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();
  List<String> _titles = [];
  bool _isGenerating = false;
  final TextEditingController _textController = TextEditingController();

  Future<void> _generateTitles() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final titles = await _titleGenerator.generateTitles(_textController.text);
      setState(() {
        _titles = titles;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating titles: $e')),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title Generator Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                border: OutlineInputBorder(),
                hintText: 'Enter text to generate titles from...',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateTitles,
              child: _isGenerating 
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Generate Titles'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            if (_titles.isNotEmpty) ...[
              Text(
                'Generated Titles:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _titles.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text(_titles[index]),
                      leading: Icon(Icons.title),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
```

## Platform Support

### iOS
- Uses Apple's NaturalLanguage framework
- Advanced NLP capabilities including part-of-speech tagging
- Generates titles based on noun and adjective combinations
- Leverages iOS-specific language processing features

### Android
- Uses platform-specific text processing
- Splits text into words and creates meaningful combinations
- Filters out short words and common stop words
- Optimized for Android performance

## API Reference

### TitleGeneratorPlugin

The main class for generating titles from text.

#### Methods

##### `Future<List<String>> generateTitles(String text)`
Generates smart titles from the provided text using platform-specific NLP capabilities.

**Parameters:**
- `text` (String): The input text to generate titles from

**Returns:**
- `Future<List<String>>`: A list of generated titles. If generation fails, returns a list with an error message.

**Example:**
```dart
final titles = await titleGenerator.generateTitles("Your article content here");
```

##### `Future<String?> getPlatformVersion()`
Returns the platform version string for debugging purposes.

**Returns:**
- `Future<String?>`: Platform version information

**Example:**
```dart
final version = await titleGenerator.getPlatformVersion();
print('Platform version: $version');
```

## Error Handling

The plugin handles errors gracefully and returns error messages in the result list rather than throwing exceptions. This makes it easier to handle errors in your application.

```dart
List<String> titles = await titleGenerator.generateTitles(text);
if (titles.length == 1 && titles[0].startsWith('Error:')) {
  // Handle error case
  print('Generation failed: ${titles[0]}');
} else {
  // Process successful results
  for (String title in titles) {
    print('Generated title: $title');
  }
}
```

## Example

Run the example app to see the plugin in action:

```bash
cd example
flutter run
```

The example app demonstrates:
- Basic title generation
- Error handling
- UI integration
- Real-time title generation

## Contributing

We welcome contributions! Please feel free to submit issues or pull requests.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Code Style

This project follows the [Dart style guide](https://dart.dev/guides/language/effective-dart/style) and uses `flutter_lints` for code analysis.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions:

- [GitHub Issues](https://github.com/your-username/title_generator_plugin/issues)
- [GitHub Discussions](https://github.com/your-username/title_generator_plugin/discussions)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.
