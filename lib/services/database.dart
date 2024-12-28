import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_project/models/llmUser.dart';
import 'package:llm_project/models/user.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // Reference to the llm_users collection
  final CollectionReference llmUserCollection =
  FirebaseFirestore.instance.collection('llm_users');

  // Update user data with API keys
  Future<void> updateUserData(String name, String openAIKey, String geminiKey, String mistralKey,
      int numberOfKeys) async {
    return await llmUserCollection.doc(uid).set({
      'name': name,
      'openAIKey': openAIKey,
      'geminiKey': geminiKey,
      'mistralKey': mistralKey,
      'numberOfKeys': numberOfKeys,
    });
  }

  // Parse llm_user list from Firestore snapshot
  List<LLMUser> llmUserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return LLMUser(
        name: doc['name'] ?? '',
        openAIKey: doc['openAIKey'] ?? '',
        geminiKey: doc['geminiKey'] ?? '',
        mistralKey: doc['mistralKey'] ?? '',
        numberOfKeys: doc['numberOfKeys'] ?? 0,
      );
    }).toList();
  }

  // Parse userData from Firestore snapshot
  UserData userDataFromSnapshots(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>?;
    return UserData(
      uid: uid!,
      name: data?['name'] ?? '',
      openAIKey: data?['openAIKey'] ?? '',
      geminiKey: data?['geminiKey'] ?? '',
      mistralKey: data?['mistralKey'] ?? '',
      numberOfKeys: data?['numberOfKeys'] ?? 0,
    );
  }

  // Stream for llm_users
  Stream<List<LLMUser>> get llm_users {
    return llmUserCollection.snapshots().map(llmUserListFromSnapshot);
  }

  // Stream for user data
  Stream<UserData> get userData {
    return llmUserCollection.doc(uid).snapshots().map(userDataFromSnapshots);
  }
}
