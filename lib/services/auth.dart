import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';

class AuthService {

  final FirebaseAuth _auth= FirebaseAuth.instance;
  //the underscore means tht this property is private, we cna only use it in this file

  //Create user obj based on Firebase User
  User _userFromFirebaseUser(FirebaseUser user) {

    return user != null ? User(uid: user.uid) : null ;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    //turns to
    .map(_userFromFirebaseUser);
    //since we cant too return users of type User and not of type Firebaseuser
    //we're gonna map this to a stream of users based on User class
    //inside this map we're gonna use afunction
    //where we pass the firebaseUser and inside the function we'll return the User format of the user
    //so everytime we get back a firebase user from the stream
    //we're gonna map that to a normal user based on our User class
  }
  //this stream returns the data of type FirebaseUser
  //its a getter
  //and it returns to us a user
  //since it's built into the firebaseauth library
  //We're gonna use the _auth instance to grab that
  //we're returnning this stream on the auth instance
  //and it's gonna return to us a firebase user whenever we change authentication
  
  

  // sign in anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
Future signInWithEmailAndPassword(String email, String password) async {
    //we make a request to firebase via the _auth variable which is of type FirebaseAuth
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password); 
      FirebaseUser user = result.user;

      
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;

    }

  }



  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    //we make a request to firebase via the _auth variable which is of type FirebaseAuth
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password); 
      FirebaseUser user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;

    }

  }


  //sign out
  Future signOut() async {

    try{

      return await _auth.signOut(); 
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


}