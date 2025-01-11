import 'package:flutter/material.dart';
import 'package:llm_project/models/user.dart';
import 'package:llm_project/services/database.dart';
import 'package:llm_project/shared/constants.dart';
import 'package:llm_project/shared/loading.dart';
import 'package:provider/provider.dart';
import '../../services/api_key_manager.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  String? _currentName;
  String? _openAIKey;
  String? _geminiKey;
  String? _mistralKey;
  int _numberOfKeys = 0;  // Store the number of keys

  @override
  void initState() {
    super.initState();
    _loadApiKeysCount();
  }

  // Load number of keys from .env and update the state
  Future<void> _loadApiKeysCount() async {
    int keyCount = await ApiKeyManager.getNumOfKeys();
    setState(() {
      _numberOfKeys = keyCount;
    });
    print("Number of keys: $_numberOfKeys");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user?.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Align(
            alignment: Alignment.center,  // Keep form centered
            child: Container(
              width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Update Your Name & Keys",
                          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25.0),

                        // Name Field
                        TextFormField(
                          initialValue: userData?.name,
                          decoration: textInputDecoration.copyWith(labelText: "Name"),
                          validator: (val) => val!.isEmpty ? "Enter a name" : null,
                          onChanged: (val) => setState(() => _currentName = val),
                        ),
                        SizedBox(height: 20.0),

                        // API Keys
                        TextFormField(
                          initialValue: ApiKeyManager.getApiKey('openai'),
                          decoration: textInputDecoration.copyWith(labelText: "OpenAI API Key"),
                          onChanged: (val) => _openAIKey = val,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: ApiKeyManager.getApiKey('gemini'),
                          decoration: textInputDecoration.copyWith(labelText: "Gemini API Key"),
                          onChanged: (val) => _geminiKey = val,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: ApiKeyManager.getApiKey('mistral'),
                          decoration: textInputDecoration.copyWith(labelText: "Mistral API Key"),
                          onChanged: (val) => _mistralKey = val,
                        ),

                        SizedBox(height: 35.0),

                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Update API Keys in .env file
                              if (_openAIKey != null) {
                                await ApiKeyManager.updateApiKey('openai', _openAIKey!);
                              }
                              if (_geminiKey != null) {
                                await ApiKeyManager.updateApiKey('gemini', _geminiKey!);
                              }
                              if (_mistralKey != null) {
                                await ApiKeyManager.updateApiKey('mistral', _mistralKey!);
                              }
                              // Reload key count after updating
                              await _loadApiKeysCount();

                              await DatabaseService(uid: user?.uid).updateUserData(
                                _currentName ?? userData!.name,
                                _numberOfKeys,
                              );
                              print('User data updated with $_numberOfKeys keys.');
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[500],
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Update', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
