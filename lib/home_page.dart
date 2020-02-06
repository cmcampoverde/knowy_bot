import 'package:flutter/material.dart';
import 'package:knowy_bot/Comments_Page.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Helpers/login_state.dart';
import 'package:knowy_bot/login_page.dart';
import 'package:knowy_bot/posibleClients_page.dart';
import 'package:knowy_bot/recommendation_page.dart';
import 'package:knowy_bot/search_page.dart';
import 'package:provider/provider.dart';

import 'Helpers/Utils.dart';
import 'SearchPage.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Busqueda", Icons.search),
    new DrawerItem("Posibles clientes", Icons.person),
    new DrawerItem("Búsqueda Completa", Icons.search),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  static const String TEXT_CERRAR_SESION= "Cerrar sesión";

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        Utils.selectRandomPost();
        return new CommentPage();
      case 1:
        return new posibleClients_page();
      case 2:
        return new SearchPageComplete();
        default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);

    Navigator.of(context).pop(); // close the drawer
  }

  static const List<Choice> choices = const <Choice>[
    const Choice(title: TEXT_CERRAR_SESION, icon: Icons.arrow_forward_ios)
  ];
  static Choice _selectedChoice;

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      if(choice.title==TEXT_CERRAR_SESION){
        Provider.of<LoginState>(context,listen: false).logout();
      }
    });
  }
  Widget renderAppBar(){
    return AppBar(
        title: const Text('KnowyBot'),
        actions: <Widget>[
          // action button

          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(children: <Widget>[
                    Text(choice.title),
                    Icon(choice.icon),
                  ],)
                );
              }).toList();
            },
          ),]);

  }


  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      appBar: renderAppBar(),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(ExpressConnection.currentUser.persona.nombre),
                accountEmail: new Text(ExpressConnection.currentUser.persona.correo),

            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}