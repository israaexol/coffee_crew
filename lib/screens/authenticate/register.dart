import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';

class Register extends StatefulWidget {

  //we need the constructor in the widget itself not the state object
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

    final AuthService _auth = AuthService();
    final _formKey = GlobalKey<FormState>();
    //we need a validation bfore making any request for firebase to create a new user
    //so we'll use flutter built in validation features
    //we define a form key (private) and this key will be used to identify our form
    //and we'll associate our form with this global form state key
    //in the form widget

  //text field state
  String email = '';
  String password = '';
  String error ='';
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold( 
      backgroundColor: Colors.brown[100],
      appBar: AppBar(  
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              widget.toggleView();

             }, 
          icon: Icon(Icons.person),
           label: Text('Sign in')
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
                //we'll just put a contraint that the email field mustnt be empty for now
                //if that's the case we'll return null meaning it is valid
                onChanged: (val) {
                  setState(() => email = val);

                },
              ),
              SizedBox(height: 20.0),
              TextFormField( 
                decoration: textInputDecoration.copyWith(hintText: 'Password'), 
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null ,
                obscureText: true,
                onChanged: (val){
                  setState(() => password = val);

                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(  
                color: Colors.pink[400],
                child: Text( 
                  'Register',
                  style: TextStyle(  
                    color: Colors.white
                  ),

                ),
                onPressed: () async {
                  //checking if the form is valid or not (based on the user's entries of email and psw)
                  if (_formKey.currentState.validate()) {
                    setState(() => loading =true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        error ='Please supply a valid email';
                        loading =  false;
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