class MyUser{

  final String uid;

  MyUser({required this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String openAIKey;
  final String geminiKey;
  final String mistralKey;
  final int numberOfKeys;

  UserData({
    required this.uid,
    required this.name,
    required this.openAIKey,
    required this.geminiKey,
    required this.mistralKey,
    required this.numberOfKeys,
  });
}
