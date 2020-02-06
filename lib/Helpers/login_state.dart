import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import  'Connection.dart';

class LoginState with ChangeNotifier{
  bool _loggedIn = false;

  bool isLoggedIn() => _loggedIn;

  void login(){
   // Connection con=new Connection();
   // con.getUsers();
    _loggedIn = true;
    notifyListeners();
  }

  void logout(){
    _loggedIn = false;
    notifyListeners();
  }
}