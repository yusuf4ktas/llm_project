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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.grey.shade300,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: SettingsForm(),
          );
        },
      );
    }

    return StreamProvider<List<LLMUser>?>.value(
      value: DatabaseService().llm_users,
      initialData: null,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade300, Colors.blueAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ModelVerse",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _auth.signOut();
                          },
                          icon: Icon(Icons.logout, color: Colors.white, size: 28),
                        ),
                        IconButton(
                          onPressed: _showSettingsPanel,
                          icon: Icon(Icons.settings, color: Colors.white, size: 28),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // User List in Card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LLMUsersList(),
                      ),
                    ),
                  ),
                ),
              ),

              // Go to Chat Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ).copyWith(
                    elevation: WidgetStateProperty.all(5),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return Colors.transparent;
                      },
                    ),
                    shadowColor: WidgetStateProperty.all(Colors.black54),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent.shade200, Colors.lightBlueAccent.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Go to Chat",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
