import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

     final user = Provider.of<User>(context);

    return StreamBuilder<UserData >(
      stream: DatabaseService(uid: user.uid).userData, //we need to use the stream provided in the DatabseSerice class
      //we have access to the user who has logged in via the provider
      //used in the wrapper
      builder: (context, snapshot) {
        //the snapshot argument here has nothing to do with firebase
        //it's a reference of the data as it comes down the stream
        //it's flutter's implementation of data coming down the stream
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
          key: _formKey,
          child: Column(  
            children: <Widget>[
              Text(  
                'Update your brew settings',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextFormField( 
                initialValue: userData.name,
                decoration: textInputDecoration,
                validator: (val) => val.isEmpty ? 'Please enter a name': null,
                onChanged: (val) => setState(() => _currentName=val),
              ),
              SizedBox(height: 20.0),
              //drop down
              DropdownButtonFormField( 
                decoration: textInputDecoration,
                isDense: true, 
                value: _currentSugars ?? userData.sugars,
                items: sugars.map((sugar) {
                  return DropdownMenuItem( 
                    value: sugar,
                    child: Text('$sugar sugars'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentSugars=val),
              ),
              //slider
              Slider(  
                value: (_currentStrength ?? userData.strength).toDouble(),
                activeColor: Colors.brown[_currentStrength ?? userData.strength],
                inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                min: 100,
                max: 900,
                divisions: 8,
                onChanged: (val) => setState(() => _currentStrength= val.round()),
              ),
              RaisedButton( 
                color: Colors.pink[400],
                child: Text(  
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async { //async because when the user enters their preferences here
                //we'll communicate with firestore in order to update the record
                  if(_formKey.currentState.validate()){
                    await DatabaseService(uid: user.uid).updateUserData(
                      _currentSugars ?? userData.sugars,
                      _currentName ?? userData.name,
                      _currentStrength ?? userData.strength
                      //if none of the settings is updated, meaning _current(i) is still null
                      //we're gonna update using the current data (the initial one before opening the form)
                      );
                      Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        );
        }
        else {
          return Loading();
        }
        
      }
    );
  }
}

//We can use the stream builder in case we need to listen to data in one widget only
//we don't have to surround the whole widget with a provider because it may cause few issues
//with the child widgets