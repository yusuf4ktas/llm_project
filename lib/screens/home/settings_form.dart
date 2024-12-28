import 'package:flutter/material.dart';
import 'package:llm_project/models/user.dart';
import 'package:llm_project/services/database.dart';
import 'package:llm_project/shared/constants.dart';
import 'package:llm_project/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // Form values
  String? _currentName;
  String? _openAIKey;
  String? _geminiKey;
  String? _mistralKey;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user?.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),  // Stronger rounding
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
                        "Update your settings & keys",
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

                      // API Keys
                      TextFormField(
                        initialValue: userData?.openAIKey ?? '',
                        decoration: textInputDecoration.copyWith(labelText: "OpenAI API Key"),
                        onChanged: (val) => setState(() => _openAIKey = val),
                      ),
                      TextFormField(
                        initialValue: userData?.geminiKey,
                        decoration: textInputDecoration.copyWith(labelText: "Gemini API Key"),
                        onChanged: (val) => setState(() => _geminiKey = val),
                      ),
                      TextFormField(
                        initialValue: userData?.mistralKey,
                        decoration: textInputDecoration.copyWith(labelText: "Mistral API Key"),
                        onChanged: (val) => setState(() => _mistralKey = val),
                      ),

                      SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await DatabaseService(uid: user?.uid).updateUserData(
                              _currentName ?? userData!.name,
                              _openAIKey ?? userData!.openAIKey,
                              _geminiKey ?? userData!.geminiKey,
                              _mistralKey ?? userData!.mistralKey,
                              userData!.numberOfKeys,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[500],
                          minimumSize: Size(double.infinity, 50),  // Full-width button
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
