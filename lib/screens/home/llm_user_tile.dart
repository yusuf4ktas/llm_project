import 'package:flutter/material.dart';
import 'package:llm_project/models/llmUser.dart';

class LLMUserTile extends StatelessWidget {
  final LLMUser? llm_user;

  LLMUserTile({this.llm_user});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.lightBlue[(llm_user!.numberOfKeys +1) * 100],
          ),
          title: Text(llm_user!.name),
          subtitle: Text('Has ${llm_user!.numberOfKeys} keys in his account'),
        ),
      ),
    );
  }
}
