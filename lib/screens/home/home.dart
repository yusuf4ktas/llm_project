import 'package:flutter/material.dart';
import 'package:llm_project/screens/home/llmUsers_list.dart';
import 'package:llm_project/screens/home/settings_form.dart';
import 'package:llm_project/services/auth.dart';
import 'package:llm_project/services/database.dart';
import 'package:provider/provider.dart';
import '../../models/llmUser.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 120.0),
            child: SettingsForm(),
          );
        },
      );
    }

    return StreamProvider<List<LLMUser>?>.value(
      value: DatabaseService().llm_users,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[800],
          title: const Text("Home"),
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.logout_outlined),
              label: Text('Log Out'),
            ),
            TextButton.icon(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
              onPressed: () => _showSettingsPanel(),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: LLMUsersList(), // Display the list of users
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                icon: Icon(
                  Icons.chat,
                  size: 26, // Make the icon larger
                ),
                label: Text(
                  "Go to Chat",
                  style: TextStyle(fontSize: 18), // Larger font size for the label
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent, // Button color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50), // Larger padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
