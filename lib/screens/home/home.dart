import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/models/brew.dart';

//we've defines a stream in the database file
//and we're gonna use the provider package to listen to that stream


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    //we declare this inside the build function because we need to access the context via the bottomsheet function
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder:(context) {
        return Container( 
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      }
      );
       //the builder is the function that actually builds the widget tree that will sit inside the bottom sheet itself
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
          child: Scaffold(  
        backgroundColor: Colors.brown[50],
        appBar: AppBar(  
          title: Text('Brew Crew'),
          backgroundColor:Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(    
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              }
            ),
            FlatButton.icon(
              onPressed: () => _showSettingsPanel(), 
              icon: Icon(Icons.settings), 
              label: Text('settings')
              )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(  
            image: DecorationImage( 
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover
            )
          ),
          child: BrewList()
          ),
      ),
    );
  }
}