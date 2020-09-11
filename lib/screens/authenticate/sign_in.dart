import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';


class SignIn extends StatefulWidget {

  //we need the constructor in the widget itself not the state object
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //to store the value/State of the fields
  String email ='';
  String password = '';
  String error ='';


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold( 
      backgroundColor: Colors.brown[100],
      appBar: AppBar(  
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              widget.toggleView();
          }, 
          icon: Icon(Icons.person),
           label: Text('Register')
           )
        ],
      ),
      body: Container(  
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:50.0),
        child: Form( 
          key: _formKey,
          child: Column(  
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                 decoration: textInputDecoration.copyWith(hintText: 'E-mail'), 
                 validator: (val) => val.isEmpty ? 'Enter an email' : null ,
                onChanged: (val) {
                  setState(() => email = val);

                },
              ),
              SizedBox(height: 20.0),
              TextFormField(  
                decoration: textInputDecoration.copyWith(hintText: 'Password'), 
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null ,
                onChanged: (val){
                  setState(() => password = val);

                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(  
                color: Colors.pink[400],
                child: Text( 
                  'Sign in',
                  style: TextStyle(  
                    color: Colors.white
                  ),

                ),
                onPressed: () async {

                 if (_formKey.currentState.validate()) {
                   setState(() => loading = true);
                   dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                      error = 'Could not sign in with those credentials';
                      loading = false;
                      });
                    } 
                    //we do not put an else statement because the stream is already processing
                    //this kind of treatment , when the user registers, he's gonna be signed in
                    //thus the stream will allow us to automatically load the home page
                    //cause the stream is constantly listening for any auth change
                  }

                },
              ),
              SizedBox(height:12.0),
            Text(  
              error, 
              style: TextStyle(  
                color: Colors.red,
                fontSize: 14.0,
              ),
            )
            ],
          ),
        ),



        /* RaisedButton(  
          child: Text('Sign in anonymously'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null) {
              print('error signing in');
            }
            else {
              print('user signed in ');
              print(result.uid);
               }
          },
        ),*/
      ),
    );
  }
}