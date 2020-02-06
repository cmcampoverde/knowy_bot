import 'package:flutter/material.dart';
import 'package:knowy_bot/Helpers/login_state.dart';
import 'package:knowy_bot/GetCurrentLocation.dart';
import 'package:knowy_bot/home_page.dart';
import 'package:knowy_bot/login_page.dart';
import 'package:knowy_bot/preferences_page.dart';
import 'package:knowy_bot/register_page.dart';
import 'package:knowy_bot/search_page.dart';
import 'package:provider/provider.dart';

import 'Connection/ExpressConnection.dart';
import 'Helpers/Utils.dart';
import 'PostDetail.dart';
import 'SearchPage.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget{



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<LoginState>(

      child: MaterialApp(
      title: 'KnowyBot',
      theme: ThemeData(
        dividerColor: Colors.grey,
        primarySwatch: Colors.teal,
        buttonTheme: ButtonThemeData(height: 45),
        textTheme: TextTheme(
          subhead: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
        routes: {
        '/': (BuildContext context) {
          var state =  Provider.of<LoginState>(context);
          if (state.isLoggedIn()) {
            return HomePage();
          } else {
            return LoginPage();//LoginPage();
            }
        },
        '/home_page': (BuildContext context) => HomePage(),
        '/register' : (BuildContext context) => RegistrationPage(),
        '/preferences_page' : (BuildContext context) => PreferencesPage(),
        '/post_detail' : (BuildContext context) => DetailPage(),
        '/sampleMap' : (BuildContext context) => GetCurrentLocation(),
        '/searchPage' : (BuildContext context) => SearchPageComplete(),
      },
    ), create: (BuildContext context) => LoginState(),
    );
  }
}

