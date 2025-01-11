import 'package:flutter/material.dart';
import 'package:llm_project/shared/loading.dart';
import '../../services/auth.dart';
import 'package:llm_project/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade200, Colors.blueGrey.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent.shade700,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email, color: Colors.blueAccent.shade400)),
                        validator: (val) =>
                        val!.isEmpty ? "Email field can't be empty" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock, color: Colors.blueAccent.shade400)),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? "Password must be 6+ characters"
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                          backgroundColor: Colors.lightBlueAccent.shade400,
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.registerWithEmailAndPassword(
                                email, password);
                            if (result == null) {
                              setState(() {
                                error = "Invalid email";
                                loading = false;
                              });
                            }
                          }
                        },
                        child: Text("Register", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800)),
                      ),
                      SizedBox(height: 20),

                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text(
                          "Already have an account? Sign In",
                          style: TextStyle(
                            color: Colors.lightBlueAccent.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
