import 'package:flutter/material.dart';
import 'package:llm_project/services/api_key_manager.dart';
import 'package:llm_project/services/openai_service.dart';
import 'package:llm_project/services/gemini_service.dart';
import 'package:llm_project/services/mistral_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedModel = 'OpenAI';
  final List<String> models = ['OpenAI', 'Gemini', 'Mistral'];
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final input = _controller.text;
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': input});
      _isLoading = true;
    });
    _controller.clear();

    String? apiKey = await ApiKeyManager.getApiKey(_selectedModel.toLowerCase());
    print("API Key for $_selectedModel: $apiKey");

    if (apiKey == null || apiKey == 'Missing API Key') {
      setState(() {
        _messages.add({'sender': 'error', 'message': 'API Key for $_selectedModel is missing or invalid'});
        _isLoading = false;
      });
      return;
    }

    String response;
    try {
      var result;
      switch (_selectedModel) {
        case 'OpenAI':
          final service = OpenAIService(apiKey);
          result = await service.chat(input);
          break;
        case 'Gemini':
          final service = GeminiService(apiKey);
          result = await service.chat(input);
          break;
        case 'Mistral':
          final service = MistralService(apiKey);
          result = await service.chat(input);
          break;
        default:
          result = "Unsupported model.";
      }
      response = result is List<String> ? result.join('\n') : result.toString();
    } catch (e) {
      response = "Error: ${e.toString()}";
    }

    setState(() {
      _messages.add({'sender': 'bot', 'message': response});
      _isLoading = false;
    });
  }

  Widget _buildChatBubble(String message, String sender) {
    bool isUser = sender == 'user';
    bool isError = sender == 'error';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isError ? Colors.red[200] : isUser ? Colors.blue[200] : Colors.green[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isUser ? Radius.circular(15) : Radius.circular(0),
            bottomRight: isUser ? Radius.circular(0) : Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with LLMs"),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          DropdownButton<String>(
            value: _selectedModel,
            items: models.map((model) => DropdownMenuItem(value: model, child: Text(model))).toList(),
            onChanged: (value) {
              setState(() => _selectedModel = value!);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message['message']!, message['sender']!);
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Divider(height: 1),
          _messageInputField(),
        ],
      ),
    );
  }

  Widget _messageInputField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Type your message...")),
          ),
          ElevatedButton(onPressed: _isLoading ? null : _sendMessage, child: Text("Send")),
        ],
      ),
    );
  }
}
