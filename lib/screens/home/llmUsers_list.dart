import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/llmUser.dart';
import 'llm_user_tile.dart';

class LLMUsersList extends StatefulWidget {
  const LLMUsersList({super.key});

  @override
  State<LLMUsersList> createState() => _LLMUsersListState();
}

class _LLMUsersListState extends State<LLMUsersList> {
  @override
  Widget build(BuildContext context) {

    final llm_users = Provider.of<List<LLMUser>?>(context) ?? [];


    return ListView.builder(
      itemCount: llm_users.length,
      itemBuilder: (context,index) {
        return LLMUserTile(llm_user : llm_users[index]);
      },
    );
  }
}
