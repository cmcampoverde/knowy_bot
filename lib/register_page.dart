
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/Persona.dart';
import 'package:knowy_bot/Models/User.dart';

class RegistrationPage extends StatefulWidget{
  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPage createState() => _RegistrationPage();



}

class _RegistrationPage extends State<RegistrationPage>{
  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        fontSize: 16.0);
  }

  ExpressConnection expressConnection =new ExpressConnection();
  final nameController =TextEditingController();
  final usernameController =TextEditingController();
  final emailController =TextEditingController();
  final telefonoController =TextEditingController();
  final passwordController =TextEditingController();
  final passwordConfirmController =TextEditingController();

   bool validarCampos(){
    if(nameController.text.isEmpty){
      showToast("Ingrese un nombre válido");
      return false;
    }
      if(usernameController.text.isEmpty){
        showToast("Username incorrecto");
        return false;
      }
      if(emailController.text.isEmpty){
        showToast("Email incorrecto");
        return false;}
      if(telefonoController.text.isEmpty){
        showToast("Telefono incorrecto");
        return false;}
      if(passwordController.text.isEmpty)return false;
      if(passwordController.text.length<5)return false;
      if(passwordConfirmController.text.isEmpty)return false;
      if(passwordController.text!=passwordConfirmController.text){
        showToast("Las contraseñas no coinciden");
        return false;}
      return true;

  }

  Future<bool> guardarUsuario()async{
      User user= new User(new Random().nextInt(99999).toString(),
          new Persona(null,new Random().nextInt(99999).toString(), nameController.text, emailController.text, telefonoController.text),
          usernameController.text,
          passwordController.text,
          emailController.text);
      return expressConnection.createUserValidando(user);
  }

  Widget renderTitleText(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,80,10,0),
      child: Text('Registrate',
        style: TextStyle(fontWeight: FontWeight.bold
            ,fontSize: 30),
        textAlign: TextAlign.center,),
    );
  }
  Widget

  renderNameInput(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(hintText: 'Nombre completo'),
      ),
    );
  }
  Widget renderUsernameInput(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: usernameController,
        decoration: InputDecoration(hintText: 'Nombre de usuario'),
      ),
    );
  }
  Widget renderCorreoInput(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(hintText: 'Correo Electrónico'),
      ),
    );
  }
  Widget renderPhoneInput(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: telefonoController,
        decoration: InputDecoration(hintText: 'Teléfono'),
      ),
    );
  }

  Widget renderPasswordInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(hintText: 'Contraseña'),
        obscureText: true,
      ),
    );
  }

  Widget renderPasswordConfirmInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,30),
      child: TextFormField(
        controller: passwordConfirmController,
        decoration: InputDecoration(hintText: 'Confirma tu contraseña'),
        obscureText: true,
      ),
    );
  }

  Widget renderRegisterButton(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top:32),
      child: RaisedButton(
        textColor: Colors.white,
        child: Text('Guardar'),
        onPressed: ()async{
          if(validarCampos()){
            if(await guardarUsuario())
               Navigator.of(context).pushNamed('/preferences_page');
          }
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(color:Colors.white),
          child:ListView(
            children: [
              renderTitleText(),
             renderNameInput(),
             renderUsernameInput(),
             renderCorreoInput(),
             renderPhoneInput(),
              renderPasswordInput(),
              renderPasswordConfirmInput(),
              renderRegisterButton(context)
            ],
          )
      )
    );
  }

}