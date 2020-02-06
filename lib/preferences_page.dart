
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/PageType.dart';

import 'Helpers/Utils.dart';
import 'Models/Preferencia.dart';


class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPage createState() => new _PreferencesPage();
}

class _PreferencesPage extends State<PreferencesPage> {
  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        fontSize: 16.0);
  }
  ExpressConnection firebaseConnection=new ExpressConnection();
  @override
  void initState() {
    super.initState();
    values=new Map<String,bool>();
    palabrasClave = new Map<String,String>();
    String tipo;
    for(int i=0;i<ExpressConnection.currentTypes.length;i++){
      tipo = ExpressConnection.currentTypes.elementAt(i).tipo;
      values.putIfAbsent(tipo, ()=>false);
      palabrasClave.putIfAbsent(tipo,()=>"");
    }
  }


  Map<String,bool> values ;
  static Map<String , String> palabrasClave;

  List<Preferencia> typesSelected = new List<Preferencia>();

 Future<bool> getCheckboxItems()async {
    Map<String,String>tmpArray;
    Preferencia preferencia;
    values.forEach((key, value) {
      if (value == true) {
       /* tmpArray=new Map<String,String>();
       // tmpArray.putIfAbsent('id_usuario',()=>ExpressConnection.currentUser.id);
        tmpArray.putIfAbsent('id_persona',()=>ExpressConnection.currentUser.persona.idBd);
        tmpArray.putIfAbsent('tipo',()=>key);
        tmpArray.putIfAbsent('palabrasClave', ()=>palabrasClave[key]);
        tmpArray.putIfAbsent('ubicacion', ()=>'Quito');
        typesSelected.add(tmpArray);

        */
      typesSelected = new List<Preferencia>();
       preferencia=new Preferencia(null, ExpressConnection.currentUser,ExpressConnection.currentUser.persona,ExpressConnection.currentTypes.firstWhere((type)=>(type.tipo==key)),"Quito",palabrasClave[key]);
      typesSelected.add(preferencia);
      }
    });
    if(typesSelected.length==0){
      showToast("No eligió ninguna preferencia");
      return false;
    }else
    return await firebaseConnection.savePreferencias(typesSelected);
  }

  Widget renderCheckboxPreferences(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 40),
      child: new ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children:  values.keys.map((String key) {
          final controllerTemp = TextEditingController();
          return Column(children: <Widget>[
          new CheckboxListTile(
          title: new Text(key),
          value: values[key],
          onChanged: (bool value) {
          setState(() {
          values[key] = value;
          palabrasClave[key] = controllerTemp.text;
          });
          },
          ),
          TextFormField(
          decoration: InputDecoration(hintText: 'Palabras clave'),
          controller: controllerTemp,)
          ],);
        }).toList(),

      ) ,
    );
  }

  Widget renderConfirmButton(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top:32),
      child: RaisedButton(
        textColor: Colors.white,
        child: Text('Guardar'),
        onPressed: ()async
        {
          if(await getCheckboxItems()){
            ExpressConnection expressConnection = new ExpressConnection();
            await expressConnection.getRecomendations();
            await expressConnection.getPersonasByRecommendations(ExpressConnection.currentUser);
            await expressConnection.getMyPagesTypes();
            await expressConnection.getMyDislikePosts();
            Utils.selectRandomPost();
              Navigator.of(context).pushNamed('/home_page');
          }
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Preferencias')),
      body:Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          renderCheckboxPreferences(),
          renderConfirmButton(context),
        ],
      )
      ),
    );
  }
}
