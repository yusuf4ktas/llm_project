import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

class ApiKeyManager {
  static String? getApiKey(String model) {
    switch (model) {
      case 'openai':
        return dotenv.env['OPENAI_API_KEY'];
      case 'gemini':
        return dotenv.env['GEMINI_API_KEY'];
      case 'mistral':
        return dotenv.env['MISTRAL_API_KEY'];
      default:
        return null;
    }
  }

  static Future<void> updateApiKey(String model, String newKey) async {
    Map<String, String> env = dotenv.env;

    switch (model) {
      case 'openai':
        env['OPENAI_API_KEY'] = newKey;
        break;
      case 'gemini':
        env['GEMINI_API_KEY'] = newKey;
        break;
      case 'mistral':
        env['MISTRAL_API_KEY'] = newKey;
        break;
    }
    // Convert the env map back to .env format
    String updatedEnv = env.entries.map((e) => '${e.key}=${e.value}').join('\n');

    // Save to the actual .env file
    final dir = await getApplicationDocumentsDirectory();
    final envFile = File('${dir.path}/.env');
    await envFile.writeAsString(updatedEnv);

    // Reload dotenv to reflect new changes
    await dotenv.load(fileName: envFile.path);
  }

  // Count API keys in .env file
  static Future<int> getNumOfKeys() async {
    int count = dotenv.env.entries
        .where((e) => e.key.contains('API_KEY') && e.value.isNotEmpty)
        .length;
    return count;
  }
}


