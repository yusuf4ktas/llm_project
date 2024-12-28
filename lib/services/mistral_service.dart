import 'package:mistralai_client_dart/mistralai_client_dart.dart';

class MistralService {
  final MistralAIClient client;

  MistralService(String apiKey) : client = MistralAIClient(apiKey: apiKey);

  Future<Object> chat(String prompt) async {
    final request = ChatCompletionRequest(
      model: 'mistral-small-latest',
      messages: [UserMessage(content: UserMessageContent.string(prompt))],
    );
    final result = await client.chatComplete(request: request);
    return result.choices?.first.message.content ?? 'No response';
  }
}
