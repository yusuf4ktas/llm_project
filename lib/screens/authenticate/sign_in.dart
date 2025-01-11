import "package:flutter/material.dart";
import "package:llm_project/services/auth.dart";
import "package:llm_project/shared/loading.dart";
import "../../shared/constants.dart";

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
            colors: [Colors.blueAccent.shade200, Colors.blueGrey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
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
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent.shade700,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email, color: Colors.blueAccent)),
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
                            prefixIcon: Icon(Icons.lock, color: Colors.blueAccent)),
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
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          backgroundColor: Colors.lightBlueAccent.shade400,
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailAndPassword(
                                email, password);
                            if (result == null) {
                              setState(() {
                                error = "Invalid credentials.";
                                loading = false;
                              });
                            }
                          }
                        },
                        child: Text("Sign In",
                          style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800,color: Colors.black54,),),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () => widget.toggleView(),
                        child: Text(
                          "Need an account? Register here",
                          style: TextStyle(color: Colors.blueAccent.shade400,fontSize: 16),
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
