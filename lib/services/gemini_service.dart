import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

class GeminiService {
  final String apiKey;
  GeminiService(this.apiKey);

  Future<String> chat(String prompt) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? 'No response';
  }

  // Image Upload and Analysis Method
  Future<String> analyzeImage(File imageFile, String prompt) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    // Read the image as bytes
    final imageBytes = await imageFile.readAsBytes();
    // Create a Part object with image data
    final imagePart = DataPart(
      'image/jpeg',  // MIME type for image
      imageBytes,    // Raw byte data
    );

    final response = await model.generateContent([
      Content.multi([  // Use 'multi' for multimodal input
        imagePart,     // Attach image data
        TextPart(prompt)  // Instruction for the model
      ])
    ]);

    return response.text ?? 'No description available.';
  }
}