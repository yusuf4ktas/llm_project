import "package:firebase_auth/firebase_auth.dart";
import "package:llm_project/models/user.dart";
import "package:llm_project/services/database.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a user object based on Firebase User
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Register with Email and Password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //Create a new document for the user with uid
      await DatabaseService(uid: user!.uid).updateUserData("new_member", 0);
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  //SıgnIn with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
