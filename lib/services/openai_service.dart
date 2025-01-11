import 'package:dart_openai/dart_openai.dart';

class OpenAIService {
  final String apiKey;

  OpenAIService(this.apiKey) {
    OpenAI.apiKey = apiKey;
  }

  Future<String> chat(String prompt) async {
    try {
      final response = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
            ],
          ),
        ],
      );

      return response.choices.first.message.content as String;
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }


  // Image Generation using DALL·E
  Future<String> generateImage(String prompt) async {
    try {
      final response = await OpenAI.instance.image.create(
        model: "dall-e-3",
        prompt: prompt,
        n: 1,
        size: OpenAIImageSize.size1024,
      );

      return response.data.first.url ?? 'No image generated.';
    } catch (e) {
      return 'Error generating image: $e';
    }
  }
}
