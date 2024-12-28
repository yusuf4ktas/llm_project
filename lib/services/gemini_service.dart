import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  GeminiService(this.apiKey);

  Future<String> chat(String prompt) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? 'No response';
  }
}
