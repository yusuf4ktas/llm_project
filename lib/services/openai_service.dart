import 'package:dart_openai/dart_openai.dart';

class OpenAIService {
  final String apiKey;

  OpenAIService(this.apiKey) {
    // Initialize the OpenAI instance with the provided API key
    OpenAI.apiKey = apiKey;
  }

  Future<String> chat(prompt) async {
    try {
      // Create a chat completion
      final response = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user, // Correct role as a string
            content: prompt, // User's input prompt
          ),
        ],
      );

      // Return the content of the first choice
      return (response.choices.first.message.content) as String;
    } catch (e) {
      // Catch and return errors
      return "";
    }
  }
}
