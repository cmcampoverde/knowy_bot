
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/Persona.dart';
import 'package:knowy_bot/Models/SearchData.dart';
import 'package:knowy_bot/Models/User.dart';

class SearchPageComplete extends StatefulWidget{
  SearchPageComplete({Key key}) : super(key: key);

  @override
  _SearchPageComplete createState() => _SearchPageComplete();



}

class _SearchPageComplete extends State<SearchPageComplete>{
  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        fontSize: 16.0);
  }

  static bool isSoloPublicaciones = true;

  void setOptionSearch(String selected){
    bool optionSelected=true;
    if(selected!="Solo Publicaciones")
      optionSelected=false;
    isSoloPublicaciones = optionSelected;
  }

  ExpressConnection expressConnection =new ExpressConnection();
  final palabrasClaveController =TextEditingController();
  final tiposController =TextEditingController();
  final fechaController =TextEditingController();
  final NumPaginasController =TextEditingController();
  final ciudadController =TextEditingController();
  final passwordConfirmController =TextEditingController();

  bool validarCampos(){
    if(palabrasClaveController.text.isEmpty){
      showToast("Ingrese palabras válidas");
      return false;
    }
    if(tiposController.text.isEmpty){
      showToast("Ingrese un tipo incorrecto");
      return false;
    }
    if(fechaController.text.isEmpty){
      showToast("Fecha incorrecta");
      return false;}
    if(NumPaginasController.text.isEmpty){
      showToast("Ingrese un número Páginas");
      return false;}
    return true;

  }



  Widget renderTitleText(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,80,10,0),
      child: Text('Busqueda de Información General',
        style: TextStyle(fontWeight: FontWeight.bold
            ,fontSize: 30),
        textAlign: TextAlign.center,),
    );
  }
  Widget

  renderPalabrasClaveInput(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: palabrasClaveController,
        decoration: InputDecoration(hintText: 'Palabras Clave'),
      ),
    );
  }

  renderTiposInput(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child:
        TextFormField(
          controller: tiposController,
          decoration: InputDecoration(hintText: 'Tipo de Página(Ejm: Inmobiliaria)'),
        ),

    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Calendar()
          ],
        );
      },
    );
  }

  void setDateSelected(DateTime dateTime){;
    fechaController.text=DateFormat('DD/MM/yyyy').format(dateTime);
  }

  renderFechaDesde(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: fechaController,
        decoration: InputDecoration(hintText: '(DD/MM/YYYY)'),
      ),
    );
  }

  Widget renderCalendar(){
    return  Calendar(isExpandable: true,onDateSelected: (DateTime date)=> setDateSelected(date));
  }

  renderNumPaginasDesde(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: NumPaginasController,
        decoration: InputDecoration(hintText: 'Número de Páginas a buscar'),
      ),
    );
  }

  Widget renderRadioButtons(){
    return(
        RadioButtonGroup(
            labels: <String>[
              "Solo Publicaciones",
              "Pulicaciones y Comentarios",
            ],
            onSelected: (String selected) => setOptionSearch(selected)
        )
    );
  }
  renderCiudad(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: ciudadController,
        decoration: InputDecoration(hintText: 'Ciudad de las páginas a buscar'),
      ),
    );
  }

  Widget renderSearchButton(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top:32),
      child: RaisedButton(
          textColor: Colors.white,
          child: Text('Guardar'),
          onPressed: (){
            if(validarCampos()){
              SearchData data = new SearchData(palabrasClaveController.text, 'face', fechaController.text, tiposController.text,
                  isSoloPublicaciones, false, !isSoloPublicaciones, NumPaginasController.text, ciudadController.text);
              new ExpressConnection().sendToSearchComplete(data);
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
                renderPalabrasClaveInput(),
                renderTiposInput(),
                renderNumPaginasDesde(),
                renderFechaDesde(),
                renderCalendar(),
                renderCiudad(),
                renderRadioButtons(),
                renderSearchButton(context),
              ],
            )
        )
    );
  }

}