import 'dart:io';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

class MistralService {
  final MistralAIClient client;

  MistralService(String apiKey) : client = MistralAIClient(apiKey: apiKey);

  Future<Object> chat(String prompt) async {
   try {
      final request = ChatCompletionRequest(
        model: 'mistral-small-latest',
        messages: [UserMessage(content: UserMessageContent.string(prompt))],
      );
      final result = await client.chatComplete(request: request);
     final content = result.choices?.first.message.content;
      String response = _extractContent(content);

      return cleanResponse(response);
   } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
  /// 🛠 Extract content safely based on its type
  String _extractContent(dynamic content) {
    if (content is String) {
      return content;
    } else if (content is AssistantMessageContent) {
      return content.value as String; // Assuming `.value` holds the text
    } else {
      return "Unsupported response format.";
    }
  }
  // Placeholder for future image analysis
  Future<String> analyzeImage(File imageFile) async {
    return 'Mistral does not currently support image analysis.';
  }
  String cleanResponse(String response) {
    // Remove the prefix and suffix: AssistantMessageContent.string(value: ... )
    final cleaned = response.replaceAll(RegExp(r'AssistantMessageContent\.string\(value:\s*'), '');
    return cleaned.replaceAll(RegExp(r'\)$'), '').trim();
  }
}
