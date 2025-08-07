# Title Generator Plugin - Usage Examples

This document provides comprehensive examples of how to use the Title Generator Plugin in various scenarios.

## Basic Usage

### Simple Title Generation

```dart
import 'package:title_generator/title_generator.dart';

void main() async {
  final titleGenerator = TitleGeneratorPlugin();
  
  String text = "Flutter is a popular open-source framework for building natively compiled applications for mobile, web, and desktop from a single codebase.";
  
  List<String> titles = await titleGenerator.generateTitles(text);
  
  print("Generated titles:");
  for (String title in titles) {
    print("- $title");
  }
}
```

### Error Handling

```dart
import 'package:title_generator/title_generator.dart';

Future<List<String>> generateTitlesSafely(String text) async {
  final titleGenerator = TitleGeneratorPlugin();
  
  try {
    List<String> titles = await titleGenerator.generateTitles(text);
    
    // Check if the result contains an error message
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

## Flutter Widget Examples

### Simple Text Input with Title Generation

```dart
import 'package:flutter/material.dart';
import 'package:title_generator/title_generator.dart';

class SimpleTitleGenerator extends StatefulWidget {
  @override
  _SimpleTitleGeneratorState createState() => _SimpleTitleGeneratorState();
}

class _SimpleTitleGeneratorState extends State<SimpleTitleGenerator> {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();
  final TextEditingController _textController = TextEditingController();
  List<String> _titles = [];
  bool _isLoading = false;

  Future<void> _generateTitles() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some text')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _titles = [];
    });

    try {
      final titles = await _titleGenerator.generateTitles(_textController.text);
      setState(() {
        _titles = titles;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Title Generator'),
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
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateTitles,
                child: _isLoading
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
                'Generated Titles (${_titles.length}):',
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
                            // Copy to clipboard
                            // You can use flutter/services for this
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

### Advanced Title Generator with Options

```dart
import 'package:flutter/material.dart';
import 'package:title_generator/title_generator.dart';

class AdvancedTitleGenerator extends StatefulWidget {
  @override
  _AdvancedTitleGeneratorState createState() => _AdvancedTitleGeneratorState();
}

class _AdvancedTitleGeneratorState extends State<AdvancedTitleGenerator> {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();
  final TextEditingController _textController = TextEditingController();
  List<String> _titles = [];
  bool _isLoading = false;
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'Technology',
    'Business',
    'Health',
    'Education',
    'Entertainment',
  ];

  Future<void> _generateTitles() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _titles = [];
    });

    try {
      // You could extend the plugin to accept category parameters
      final titles = await _titleGenerator.generateTitles(_textController.text);
      setState(() {
        _titles = titles;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to generate titles: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Title Generator'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Content Category',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Content',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Enter your content here...',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateTitles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Generating Titles...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome),
                            SizedBox(width: 8),
                            Text('Generate Smart Titles'),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 16),
              if (_titles.isNotEmpty) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.title, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Generated Titles',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Spacer(),
                            Chip(
                              label: Text('${_titles.length} titles'),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ...(_titles.asMap().entries.map((entry) {
                          int index = entry.key;
                          String title = entry.value;
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    // Copy functionality
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Copied to clipboard')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList()),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
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

## Service Layer Example

```dart
import 'package:title_generator/title_generator.dart';

class TitleGeneratorService {
  final TitleGeneratorPlugin _titleGenerator = TitleGeneratorPlugin();

  /// Generate titles for a given text
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

  /// Filter out error messages and invalid titles
  List<String> _filterValidTitles(List<String> titles) {
    return titles.where((title) {
      return title.isNotEmpty && 
             !title.startsWith('Error:') && 
             title.length > 3;
    }).toList();
  }

  /// Generate titles for multiple texts
  Future<Map<String, List<String>>> generateTitlesForMultiple(
    List<String> texts,
  ) async {
    Map<String, List<String>> results = {};
    
    for (String text in texts) {
      results[text] = await generateTitles(text);
    }
    
    return results;
  }
}
```

## Integration with State Management

### Using Provider

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

### Using Bloc/Cubit

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

## Testing Examples

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

    test('should get platform version', () async {
      String? version = await titleGenerator.getPlatformVersion();
      
      expect(version, isA<String?>());
    });
  });
}
```

## Performance Tips

1. **Reuse instances**: Create one instance of `TitleGeneratorPlugin` and reuse it
2. **Handle errors gracefully**: Always wrap calls in try-catch blocks
3. **Validate input**: Check for empty or very short text before processing
4. **Use async/await properly**: Don't block the UI thread with synchronous operations
5. **Cache results**: Consider caching generated titles for repeated content

## Best Practices

1. **Error handling**: Always handle potential errors from the plugin
2. **Loading states**: Show loading indicators during title generation
3. **Input validation**: Validate user input before processing
4. **User feedback**: Provide clear feedback for success and error states
5. **Accessibility**: Ensure your UI is accessible to all users 