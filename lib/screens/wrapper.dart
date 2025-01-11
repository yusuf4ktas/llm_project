import 'package:flutter/material.dart';
import 'package:llm_project/screens/authenticate/authenticate.dart';
import 'package:llm_project/models/user.dart';
import 'package:provider/provider.dart';
import 'package:llm_project/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);
    print("User state in Wrapper: $user");

    if(user == null){
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}
