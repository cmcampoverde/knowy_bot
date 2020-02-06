import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:knowy_bot/Models/Persona.dart';
import 'package:knowy_bot/Models/User.dart';

import 'network_utils.dart';

class LoginSrv {
 // LocalStorageService pref;
  NetworkUtils net;
  User usuario;
 // Cliente cliente;
  String sessionId;
  //Factura factura;
  String barcode;
  Map<String, dynamic> currentItem = Map();
  List<Map<String, dynamic>> items = List();

  LoginSrv(NetworkUtils net) {
   // this.pref = localStorageService;
    this.net = net;
  }

 /* Future<bool> isLogged() async {
    if (usuario != null) {
      return true;
    }
    if (pref.logged) {
      // estaba ya logueado, valido contra servidor esos datos
      try {
        return await login(pref.username, pref.password, null);
      } catch (e) {}
    } else {
      return false;
    }
    return false;
  }*/

  Future<bool> login(String user, String password,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    try {
      // genero token authenticacion
      var str = user + ":" + password;
      var bytes = utf8.encode(str);
      var base64Str = base64.encode(bytes);
      // vacio cookies
      net.deleteCookies();
      //net.addHeaders("Authorization", "Basic " + base64Str);
      var responseJson = await net.get("/q/zmYvkVjB?token=dAgRtbr2rua23BhdGRHiTg");
      print(responseJson);

      if (responseJson == null) {
        net.showSnackBar(_scaffoldKey, 'Something went wrong!');
      } else if (responseJson['errors'] != null) {
        net.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
      }

      // extraigo datos de inicio sesion correcto
     /* usuario = User.fromJson(responseJson['username']);
      Fluttertoast.showToast(
          msg: "Bienvenido Sr/Sra." + usuario.nombre,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);

      */
    /*  cliente = Cliente.fromJson(responseJson['cliente']);
      pref.username = user;
      pref.password = password;
      pref.logged = true;
     */
      return true;
    } catch (ex) {
      print(ex);
      if (ex.toString().contains('SocketException')) {
        net.showSnackBar(_scaffoldKey, "Error de red");
      }
      if (net.developer) {
        // return true; // temporal para diseñar pagina login
      }
      throw ex;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await net.post("/logout");
    } catch (ex) {
      net.deleteCookies();
      net.deleteHeaders("Authorization");
      usuario = null;
     /* cliente = null;
      pref.username = null;
      pref.password = null;
      pref.logged = false;
      barcode = "";
      factura = null;

      */
      currentItem = new Map();
      items = new List();
    }
  }

  signup(String nombre,
      String username,
      String telefono,
      String email,
      String password,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    try {
      User clt = new User( null, new Persona(null,null,nombre,email,telefono) ,username,password,email);

      var responseJson = await net.post("/nuevoUsuario", body: clt);
      print(responseJson);

      if (responseJson == null) {
        net.showSnackBar(_scaffoldKey, 'Something went wrong!');
      } else if (responseJson['errors'] != null) {
        net.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
      }

      return true;
    } catch (ex) {
      print(ex);
      if (ex.toString().contains('SocketException')) {
        net.showSnackBar(_scaffoldKey, "Error de red");
      }
      throw ex;
    }
  }

  /*crearFactura() async {
    var responseJson = await net.post("/llantamax/factura/nueva/" + usuario.id);
    factura = Factura.fromJson(responseJson);
  }

   */

  buscarPublicacion(String qr, GlobalKey<ScaffoldState> _scaffoldKey) async {
    currentItem = await net.get("/publicacion" + qr);
  }

 /* agregar(String cantidad, BuildContext context) async {
    var item = await net.post("/llantamax/detallefactura/" +
        currentItem['id'] +
        "/" +
        cantidad +
        "/" +
        usuario.id);
    items.add(item);
    Navigator.pushNamed(context, 'compra');
  }
  */
/*
  finalizarCompra() async {
    await net.post("/llantamax/factura/" + factura.id);
    barcode = "";
    currentItem = new Map();
    items = new List();
  }

 */

/*
  guardarMetodo(String metodo) async {
    if (metodo == "1") {
      Fluttertoast.showToast(
          msg: "Acercarse a Caja a Cancelar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    await net.post("/llantamax/factura/metodo/" + factura.id + "/" + metodo);
    currentItem = new Map();
    items = new List();
  }*/
/*
  cancelCompra() async {
    Fluttertoast.showToast(
        msg: "Compra cancelada Correctamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.white,
        fontSize: 16.0);
    currentItem = new Map();
    items = new List();
    await net.delete("llantamax/factura/" + factura.id);
    factura = null;
  }*/
}
