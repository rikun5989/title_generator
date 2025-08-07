# Title Generator Plugin - Integration Guide

This guide will help you integrate the Title Generator Plugin into your Flutter application.

## Prerequisites

- Flutter SDK 3.3.0 or higher
- Dart SDK 3.7.2 or higher
- iOS 11.0+ (for iOS support)
- Android API level 21+ (for Android support)

## Installation

### 1. Add Dependency

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  title_generator: ^0.0.1
```

### 2. Install Dependencies

Run the following command to install the dependencies:

```bash
flutter pub get
```

### 3. Platform Configuration

#### iOS Configuration

For iOS, no additional configuration is required. The plugin uses Apple's NaturalLanguage framework which is available on iOS 12.0+.

#### Android Configuration

For Android, no additional configuration is required. The plugin uses platform-specific text processing.

## Basic Integration

### Step 1: Import the Plugin

```dart
import 'package:title_generator/title_generator.dart';
```

### Step 2: Create an Instance

```dart
final TitleGeneratorPlugin titleGenerator = TitleGeneratorPlugin();
```

### Step 3: Generate Titles

```dart
// Simple usage
List<String> titles = await titleGenerator.generateTitles("Your text content here");

// With error handling
try {
  List<String> titles = await titleGenerator.generateTitles("Your text content here");
  print("Generated titles: $titles");
} catch (e) {
  print("Error generating titles: $e");
}
```

## Complete Integration Example

Here's a complete example showing how to integrate the plugin into a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:title_generator/title_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title Generator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: TitleGeneratorScreen(),
    );
  }
}

class TitleGeneratorScreen extends StatefulWidget {
  @override
  _TitleGeneratorScreenState createState() => _TitleGeneratorScreenState();
}

class _TitleGeneratorScreenState extends State<TitleGeneratorScreen> {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();
  final TextEditingController _textController = TextEditingController();
  List<String> _titles = [];
  bool _isGenerating = false;

  Future<void> _generateTitles() async {
    if (_textController.text.trim().isEmpty) {
      _showSnackBar('Please enter some text');
      return;
    }

    setState(() {
      _isGenerating = true;
      _titles = [];
    });

    try {
      final titles = await _titleGenerator.generateTitles(_textController.text);
      setState(() {
        _titles = titles;
      });
    } catch (e) {
      _showSnackBar('Error generating titles: $e');
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type or paste your content here...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateTitles,
                child: _isGenerating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Generating...'),
                        ],
                      )
                    : Text('Generate Titles'),
              ),
            ),
            SizedBox(height: 16),
            if (_titles.isNotEmpty) ...[
              Text(
                'Generated Titles:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _titles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(_titles[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            // Implement copy functionality
                            _showSnackBar('Copied to clipboard');
                          },
                        ),
                      ),
                    );
                  },
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

## Advanced Integration

### Service Layer Pattern

Create a service class to handle title generation:

```dart
import 'package:title_generator/title_generator.dart';

class TitleGeneratorService {
  static final TitleGeneratorService _instance = TitleGeneratorService._internal();
  factory TitleGeneratorService() => _instance;
  TitleGeneratorService._internal();

  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();

  Future<List<String>> generateTitles(String text) async {
    if (text.trim().isEmpty) {
      return [];
    }

    try {
      final titles = await _titleGenerator.generateTitles(text);
      return _filterValidTitles(titles);
    } catch (e) {
      print('Error generating titles: $e');
      return [];
    }
  }

  List<String> _filterValidTitles(List<String> titles) {
    return titles.where((title) {
      return title.isNotEmpty && 
             !title.startsWith('Error:') && 
             title.length > 3;
    }).toList();
  }
}
```

### State Management Integration

#### With Provider

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:title_generator/title_generator.dart';

class TitleGeneratorProvider extends ChangeNotifier {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();
  List<String> _titles = [];
  bool _isLoading = false;
  String? _error;

  List<String> get titles => _titles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generateTitles(String text) async {
    if (text.trim().isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _titles = await _titleGenerator.generateTitles(text);
      _titles = _titles.where((title) => 
        title.isNotEmpty && !title.startsWith('Error:')
      ).toList();
    } catch (e) {
      _error = e.toString();
      _titles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearTitles() {
    _titles = [];
    _error = null;
    notifyListeners();
  }
}
```

#### With Bloc

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:title_generator/title_generator.dart';

// Events
abstract class TitleGeneratorEvent {}

class GenerateTitles extends TitleGeneratorEvent {
  final String text;
  GenerateTitles(this.text);
}

class ClearTitles extends TitleGeneratorEvent {}

// States
abstract class TitleGeneratorState {}

class TitleGeneratorInitial extends TitleGeneratorState {}

class TitleGeneratorLoading extends TitleGeneratorState {}

class TitleGeneratorSuccess extends TitleGeneratorState {
  final List<String> titles;
  TitleGeneratorSuccess(this.titles);
}

class TitleGeneratorError extends TitleGeneratorState {
  final String message;
  TitleGeneratorError(this.message);
}

// Bloc
class TitleGeneratorBloc extends Bloc<TitleGeneratorEvent, TitleGeneratorState> {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();

  TitleGeneratorBloc() : super(TitleGeneratorInitial()) {
    on<GenerateTitles>(_onGenerateTitles);
    on<ClearTitles>(_onClearTitles);
  }

  Future<void> _onGenerateTitles(
    GenerateTitles event,
    Emitter<TitleGeneratorState> emit,
  ) async {
    emit(TitleGeneratorLoading());

    try {
      final titles = await _titleGenerator.generateTitles(event.text);
      final validTitles = titles.where((title) => 
        title.isNotEmpty && !title.startsWith('Error:')
      ).toList();
      
      emit(TitleGeneratorSuccess(validTitles));
    } catch (e) {
      emit(TitleGeneratorError(e.toString()));
    }
  }

  void _onClearTitles(
    ClearTitles event,
    Emitter<TitleGeneratorState> emit,
  ) {
    emit(TitleGeneratorInitial());
  }
}
```

## Error Handling

### Basic Error Handling

```dart
Future<List<String>> generateTitlesSafely(String text) async {
  final titleGenerator = TitleGeneratorPlugin();
  
  try {
    List<String> titles = await titleGenerator.generateTitles(text);
    
    // Check for error messages in the result
    if (titles.length == 1 && titles[0].startsWith('Error:')) {
      print('Title generation failed: ${titles[0]}');
      return [];
    }
    
    return titles;
  } catch (e) {
    print('Exception occurred: $e');
    return [];
  }
}
```

### Advanced Error Handling

```dart
class TitleGenerationException implements Exception {
  final String message;
  final String? originalError;
  
  TitleGenerationException(this.message, [this.originalError]);
  
  @override
  String toString() => 'TitleGenerationException: $message';
}

Future<List<String>> generateTitlesWithErrorHandling(String text) async {
  final titleGenerator = TitleGeneratorPlugin();
  
  try {
    if (text.trim().isEmpty) {
      throw TitleGenerationException('Text cannot be empty');
    }
    
    if (text.length < 10) {
      throw TitleGenerationException('Text is too short for meaningful title generation');
    }
    
    List<String> titles = await titleGenerator.generateTitles(text);
    
    // Filter out error messages
    titles = titles.where((title) => 
      title.isNotEmpty && !title.startsWith('Error:')
    ).toList();
    
    if (titles.isEmpty) {
      throw TitleGenerationException('No valid titles were generated');
    }
    
    return titles;
  } catch (e) {
    if (e is TitleGenerationException) {
      rethrow;
    }
    throw TitleGenerationException('Failed to generate titles', e.toString());
  }
}
```

## Testing

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:title_generator/title_generator.dart';

void main() {
  group('TitleGeneratorPlugin Tests', () {
    late TitleGeneratorPlugin titleGenerator;

    setUp(() {
      titleGenerator = TitleGeneratorPlugin();
    });

    test('should generate titles for valid text', () async {
      String text = "Flutter is a popular framework for mobile development";
      
      List<String> titles = await titleGenerator.generateTitles(text);
      
      expect(titles, isA<List<String>>());
      expect(titles.length, greaterThan(0));
    });

    test('should handle empty text', () async {
      List<String> titles = await titleGenerator.generateTitles("");
      
      expect(titles, isA<List<String>>());
    });

    test('should handle very short text', () async {
      List<String> titles = await titleGenerator.generateTitles("Hi");
      
      expect(titles, isA<List<String>>());
    });
  });
}
```

### Widget Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:title_generator/title_generator.dart';

void main() {
  testWidgets('Title generator widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TitleGeneratorScreen(),
    ));

    // Find the text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // Enter text
    await tester.enterText(textField, 'Test content for title generation');
    await tester.pump();

    // Find and tap the generate button
    final generateButton = find.text('Generate Titles');
    expect(generateButton, findsOneWidget);
    await tester.tap(generateButton);
    await tester.pump();

    // Wait for async operation
    await tester.pumpAndSettle();

    // Verify that titles are displayed
    expect(find.text('Generated Titles:'), findsOneWidget);
  });
}
```

## Performance Optimization

### 1. Reuse Plugin Instances

```dart
class MyApp extends StatelessWidget {
  // Create a single instance
  static final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();
  
  static TitleGeneratorPlugin get titleGenerator => _titleGenerator;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
```

### 2. Debounce User Input

```dart
import 'dart:async';

class DebouncedTitleGenerator {
  Timer? _debounceTimer;
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();

  Future<void> generateTitlesDebounced(
    String text,
    Function(List<String>) onResult,
  ) async {
    _debounceTimer?.cancel();
    
    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        final titles = await _titleGenerator.generateTitles(text);
        onResult(titles);
      } catch (e) {
        print('Error: $e');
        onResult([]);
      }
    });
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
```

### 3. Cache Results

```dart
class CachedTitleGenerator {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();
  final Map<String, List<String>> _cache = {};

  Future<List<String>> generateTitles(String text) async {
    // Check cache first
    if (_cache.containsKey(text)) {
      return _cache[text]!;
    }

    // Generate new titles
    final titles = await _titleGenerator.generateTitles(text);
    
    // Cache the result
    _cache[text] = titles;
    
    return titles;
  }

  void clearCache() {
    _cache.clear();
  }
}
```

## Troubleshooting

### Common Issues

1. **Plugin not found**: Make sure you've added the dependency to `pubspec.yaml` and run `flutter pub get`

2. **Platform-specific errors**: Ensure you're testing on the correct platform (iOS/Android)

3. **Empty results**: Check if your input text is meaningful enough for title generation

4. **Performance issues**: Consider implementing caching and debouncing for better performance

### Debug Information

```dart
// Get platform version for debugging
String? platformVersion = await titleGenerator.getPlatformVersion();
print('Platform version: $platformVersion');
```

## Best Practices

1. **Always handle errors**: Wrap plugin calls in try-catch blocks
2. **Validate input**: Check for empty or very short text
3. **Show loading states**: Provide user feedback during title generation
4. **Reuse instances**: Create one plugin instance and reuse it
5. **Test thoroughly**: Write tests for your integration
6. **Handle edge cases**: Consider what happens with very short or very long text
7. **Provide fallbacks**: Have a backup plan when title generation fails

## Support

If you encounter issues during integration:

1. Check the [README.md](README.md) for basic usage
2. Review the [USAGE_EXAMPLE.md](USAGE_EXAMPLE.md) for detailed examples
3. Check the [CHANGELOG.md](CHANGELOG.md) for recent changes
4. Open an issue on the GitHub repository
5. Check existing issues for similar problems 