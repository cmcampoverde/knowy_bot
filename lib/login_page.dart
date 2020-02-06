import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knowy_bot/Connection/network_utils.dart';
import 'package:provider/provider.dart';
import 'package:knowy_bot/Helpers/login_state.dart';
import 'package:http/http.dart' as http;

import 'Connection/ExpressConnection.dart';
import 'Connection/LoginSrv.dart';
import 'Helpers/Utils.dart';
import 'Models/User.dart';


class LoginPage extends StatefulWidget {



  static User currentUser;
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();


}

class _LoginPage extends State<LoginPage> {
  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        fontSize: 16.0);
  }

  ExpressConnection expressConnection=new ExpressConnection();

  LoginSrv loginSrv = LoginSrv(new NetworkUtils());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  final userController = TextEditingController();
  final passwordController = TextEditingController();
  Map<String,dynamic> data;
  List<User> users=new List<User>();
  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://192.168.42.167:5000/usuarios"),
        headers: {
          "Accept": "application/json"
        }
    );
    this.setState(() {
      debugPrint(response.body);

      List<User>user= jsonDecode(response.body);
      debugPrint(user.first.username);
    });


    return "Success!";
  }

insertData()  {
//expressConnection.getPosts();
}
Future<bool> authenticateUser(String username,String password) async {
    if(await expressConnection.authenticateUser(username, password)){
      LoginPage.currentUser = ExpressConnection.currentUser;
      await expressConnection.getRecomendations();
      await expressConnection.getPersonasByRecommendations(ExpressConnection.currentUser);
      await expressConnection.getMyPagesTypes();
      await expressConnection.getMyDislikePosts();
      Utils.selectRandomPost();
      return true;
    }else{
      showToast("Datos Incorrectos");
      return false;}
}


  @override
  void initState() {
    super.initState();
    incorrectData=false;
    //this.getData();
  }
  bool incorrectData;
  Widget renderEmailInput(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10,40,10,0),
      child: TextFormField(
        controller: userController,
        decoration: InputDecoration(hintText: 'Correo electrónico'),
      ),
    );
  }

  Widget renderPasswordInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,10,10,0),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(hintText: 'Contraseña'),
        obscureText: true,
      ),
    );
  }

  Widget renderLoginButton(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top:32),
      child: RaisedButton(
        textColor: Colors.white,
        child: Text('Entrar'),
        onPressed: ()async{
          if(await authenticateUser(userController.text,passwordController.text)){
             Provider.of<LoginState>(context,listen: false).login();
              //  Navigator.of(context).pushNamed('/home_page');
          }
        },
      ),
    );
  }

  Widget renderDivider(){

    return Container(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Expanded(child: Divider(height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('0'),
          ),
          Expanded(child: Divider(height: 1))
        ],
      ),
    );
  }

  Widget renderFacebookButton(){
    return Container(
      padding: const EdgeInsets.only(top: 32),
      child:RaisedButton(
        textColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.facebookSquare),
          Expanded(
            child: Text('Entrar con Facebook', textAlign: TextAlign.center,),
          ),
        ],
      ),
        onPressed: (){
          new ExpressConnection().authenticateUser("cmcampoverde", "12345");
        //  new FirebaseConnection().addDataToFirebase();
        },
      ),
    );
  }

  Widget renderCreateAccountLing(BuildContext context){
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 20),
      child: new InkWell(
          child:  Text('O crea tu cuenta aquí!',textAlign: TextAlign.right),
        onTap: () => Navigator.of(context).pushNamed('/register'),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder(
        future:  Utils.prepararData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.data==null)return Center(child: CircularProgressIndicator(), );
          else
          return(Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(color:Colors.white),
              child:ListView(
                  children: [
                    Image.asset(
                      'assets/images/logo_knowyBot.png',
                      width: 540,
                    ),
                    renderEmailInput(),
                    renderPasswordInput(),
                    renderLoginButton(context),
                    renderCreateAccountLing(context),
                    renderDivider(),
                    //renderFacebookButton(),
                  ]
              )));
        }
      ));

  }
}
