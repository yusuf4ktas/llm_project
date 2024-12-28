class LLMUser {
  final String name;
  final String openAIKey;
  final String geminiKey;
  final String mistralKey;
  final int numberOfKeys;

  LLMUser({
    required this.name,
    required this.openAIKey,
    required this.geminiKey,
    required this.mistralKey,
    required this.numberOfKeys,
  });
}
