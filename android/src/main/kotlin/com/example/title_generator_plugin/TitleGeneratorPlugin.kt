package com.example.title_generator_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TitleGeneratorPlugin */
class TitleGeneratorPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "title_generator_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "generateTitles" -> {
        val text = call.argument<String>("text")
        if (text != null) {
          val titles = generateSmartTitles(text)
          result.success(titles)
        } else {
          result.error("INVALID_ARGUMENTS", "Invalid arguments for generateTitles", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun generateSmartTitles(text: String): List<String> {
    if (text.isEmpty()) {
      return listOf("No Title Found")
    }

    // Simple title generation for Android
    // Split text into words and create combinations
    val words = text.trim().split("\\s+".toRegex())
      .filter { it.length > 2 } // Filter out very short words
      .map { it.capitalize() }

    if (words.size < 3) {
      return listOf("No Title Found")
    }

    val titles = mutableListOf<String>()
    
    // Generate 3-word combinations
    for (i in 0..words.size - 3) {
      val title = "${words[i]} ${words[i + 1]} ${words[i + 2]}"
      if (!titles.contains(title)) {
        titles.add(title)
      }
    }

    return if (titles.isEmpty()) listOf("No Title Found") else titles.take(5)
  }

  private fun String.capitalize(): String {
    return if (this.isNotEmpty()) {
      this[0].uppercase() + this.substring(1).lowercase()
    } else {
      this
    }
  }
}
