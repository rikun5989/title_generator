import Flutter
import UIKit
import NaturalLanguage

public class TitleGeneratorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "title_generator_plugin", binaryMessenger: registrar.messenger())
    let instance = TitleGeneratorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "generateTitles":
      if let args = call.arguments as? [String: Any],
         let text = args["text"] as? String {
        let titles = generateSmartTitles(from: text)
        result(titles)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", 
                           message: "Invalid arguments for generateTitles", 
                           details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func generateSmartTitles(from text: String) -> [String] {
    // Handle empty or very short text
    guard !text.isEmpty else {
      return []
    }
    
    let tagger = NLTagger(tagSchemes: [.lexicalClass])
    tagger.string = text

    let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
    var tokens: [(String, NLTag)] = []

    // Check if we have valid text bounds
    guard text.startIndex < text.endIndex else {
      return []
    }

    // Collect tagged tokens with error handling
    tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                         unit: .word,
                         scheme: .lexicalClass,
                         options: options) { tag, range in
        if let tag = tag {
            let token = String(text[range]).capitalized
            tokens.append((token, tag))
        }
        return true
    }

    // Generate 3-word title candidates with bounds checking
    var titles: [String] = []
    guard tokens.count >= 3 else {
      return []
    }
    
    for i in 0..<(tokens.count - 2) {
        let a = tokens[i]
        let b = tokens[i + 1]
        let c = tokens[i + 2]

        let allowedTags: Set<NLTag> = [.noun, .adjective]
        if allowedTags.contains(a.1), allowedTags.contains(b.1), allowedTags.contains(c.1) {
            let phrase = "\(a.0) \(b.0) \(c.0)"
            if !titles.contains(phrase) {
                titles.append(phrase)
            }
        }
    }

    return titles.isEmpty ? [] : Array(titles.prefix(5))
  }
}
