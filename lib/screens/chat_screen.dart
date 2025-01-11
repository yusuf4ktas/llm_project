import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:llm_project/services/api_key_manager.dart';
import 'package:llm_project/services/openai_service.dart';
import 'package:llm_project/services/gemini_service.dart';
import 'package:llm_project/services/mistral_service.dart';
import 'package:llm_project/shared/constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedModel = 'OpenAI';
  final List<String> models = ['OpenAI', 'Gemini', 'Mistral'];
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  File? _selectedImage;

  // Image Picker (Only for Gemini)
  Future<void> _pickImage() async {
    if (_selectedModel != 'Gemini') return; // Prevents image pick for non-Gemini models

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
    final input = _controller.text;  // Capture the text input

      setState(() {
      _selectedImage = File(image.path);
      _messages.add({
        'sender': 'user',
        'image': _selectedImage,
        'prompt': input  // Store the prompt with the image
      });
      _controller.clear();  // Clear input after sending
    });

    // Upload to the selected LLM model
    _analyzeImage(_selectedImage!, input);
  }
}
  // Analyze Image with Gemini
  Future<void> _analyzeImage(File imageFile, String prompt) async {
    setState(() {
      _isLoading = true;
    });

    String? apiKey = ApiKeyManager.getApiKey(_selectedModel.toLowerCase());
    if (apiKey == null || apiKey == 'Missing API Key') {
      setState(() {
        _messages.add({'sender': 'error', 'message': 'API Key for $_selectedModel is missing or invalid'});
        _isLoading = false;
      });
      return;
    }

    String response = "Image analysis not supported for this model.";
  
    try {
      if (_selectedModel == 'Gemini') {
        final service = GeminiService(apiKey);
        response = await service.analyzeImage(imageFile,prompt);
      }
    } catch (e) {
      response = "Error: ${e.toString()}";
    }

    setState(() {
      _messages.add({'sender': 'bot', 'message': response});
      _isLoading = false;
    });
  }

  // Send Text Message
  Future<void> _sendMessage() async {
    final input = _controller.text;
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': input});
      _isLoading = true;
    });
    _controller.clear();

    String? apiKey = ApiKeyManager.getApiKey(_selectedModel.toLowerCase());
    if (apiKey == null || apiKey == 'Missing API Key') {
      setState(() {
        _messages.add({'sender': 'error', 'message': 'API Key for $_selectedModel is missing or invalid'});
        _isLoading = false;
      });
      return;
    }

    String? response;
    try {
      switch (_selectedModel) {
        case 'OpenAI':
          final service = OpenAIService(apiKey);
          response = await service.chat(input);
          break;
        case 'Gemini':
          final service = GeminiService(apiKey);
          response = await service.chat(input);
          break;
        case 'Mistral':
          final service = MistralService(apiKey);
          response = (await service.chat(input)) as String?;
          break;
        default:
          response = "Unsupported model.";
      }
    } catch (e) {
      response = "Error: ${e.toString()}";
    }

    setState(() {
      _messages.add({'sender': 'bot', 'message': response});
      _isLoading = false;
    });
  }

  // Chat Bubble Builder
Widget _buildChatBubble(Map<String, dynamic> message) {
  bool isUser = message['sender'] == 'user';
  bool isError = message['sender'] == 'error';

  // Handle Image Display with Prompt
  if (message.containsKey('image')) {
    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Image.file(message['image'], height: 200),
        ),
        if (message.containsKey('prompt') && message['prompt']!.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message['prompt'],
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
      ],
    );
  }

  // Handle Text Message
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isError ? Colors.red[200] : isUser ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(18),
      ),
      child: RichText(
        text: parseStyledText(message['message']),
      ),
    ),
  );
}

  // Message Input with Image Button
  Widget _messageInputField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_selectedModel == 'Gemini') // Show icon only for Gemini
              IconButton(
                icon: Icon(Icons.image),
                onPressed: _pickImage,
              ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: "Type your message...",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.blueAccent,width: 2),
                  )
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendMessage,
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ModelVerse"),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.lightBlue.shade100,
                Colors.lightBlue.shade300,
              ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(_messages[index]);
                },
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
            Divider(height: 1),
            _messageInputField(),
          ],
        ),
      ),
    );
  }
}
