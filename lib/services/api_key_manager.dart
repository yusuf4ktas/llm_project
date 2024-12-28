import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiKeyManager {
  static Future<String?> getApiKey(String model) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('llm_users')  // Correct collection
        .doc(user.uid)  // Fetch document by user UID
        .get();

    if (doc.exists) {
      final data = doc.data();
      print("User Data in Firestore: $data");

      // Map model names to exact Firestore key names
      Map<String, String> keyMapping = {
        'openai': 'openAIKey',
        'gemini': 'geminiKey',
        'mistral': 'mistralKey',
      };

      // Get the correct key name from the mapping
      String? firestoreKey = keyMapping[model];

      return data?[firestoreKey] ?? 'Missing API Key';  // Graceful handling
    } else {
      print("Firestore document for user does not exist.");
      return null;
    }
  }
}
