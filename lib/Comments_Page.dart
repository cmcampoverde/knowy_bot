import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/User.dart';
import 'package:knowy_bot/Models/class%20Comment.dart';
import 'package:knowy_bot/login_page.dart';
import 'package:knowy_bot/recommendation_page.dart';
import 'package:knowy_bot/search_page.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'Helpers/Utils.dart';
import 'Models/Page.dart';
import 'Models/PageType.dart';
import 'Models/Post.dart';
import 'Models/Recommendation.dart';
import 'home_page.dart';

class CommentPage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Busqueda", Icons.search),
    new DrawerItem("Recomendaciones", Icons.library_books),
  ];


  static User currentUser=ExpressConnection.currentUser;


  @override
  _CommentPage createState() => _CommentPage();
}


class _CommentPage extends State<CommentPage>with TickerProviderStateMixin {

  final filterController =TextEditingController();
  final ubicacionContrller = TextEditingController();
  int _selectedDrawerIndex = 0;
  List<PageType>tiposBuscado= ExpressConnection.currentMyTypes;
  List<Post> misComent= ExpressConnection.currentPublicaciones;
  List<PageType>tipos = ExpressConnection.currentMyTypes;

List<Post> findByPageType(List<Post> posts,String type){
  List<Post> newList=new List<Post>();
  for(int i=0;i<posts.length;i++){
    if(type.toLowerCase()==posts[i].page.pageType.tipo.toLowerCase())
      if(!ExpressConnection.currentMyDislikePosts.contains(posts[i]))
      newList.add(posts[i]);
  }
  return newList;
}

  var appColors = [Color.fromRGBO(82, 82, 82, 1.0),Color.fromRGBO(111, 194, 173, 1.0),Color.fromRGBO(47, 79, 79, 1.0),Color.fromRGBO(64, 64, 64, 1.0),Color.fromRGBO(82, 82, 82, 1.0)];
  var cardIndex = 0;
  ScrollController commentsScrollController;
  ScrollController recomScrollController;
  ExpressConnection expressConnection = new ExpressConnection();
  var currentColor = Color.fromRGBO(82, 82, 82, 1.0);

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;

  void dislikePost(Post post)async {
    await expressConnection.dislakePost(post);
    await expressConnection.getMyDislikePosts();
    Utils.selectRandomPost();
    setState(() {
      misComent.remove(post);
    });
  }

  @override
  void initState() {
    super.initState();
    commentsScrollController = new ScrollController();
    recomScrollController = new ScrollController();
    misComent=Utils.randomPosts;

  }



  Future<List<PageType>> _getMisTipos()async{

    if(ExpressConnection.currentMyTypes!=null)return ExpressConnection.currentMyTypes;

    else if(ExpressConnection.currentTypes!=null)return ExpressConnection.currentTypes;
    return await new ExpressConnection().getMyPagesTypes();
  }

  Widget renderPostCard(ScrollController scrollController, List<Post> list){
    if(misComent == null){
      return Container(
        child:Loading(indicator: BallPulseIndicator(), size: 100.0),
      );
    }else
    return Container(
      height: 450.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          var iconRed;
          if(list[position].page.redSocial=='Facebook'){
            iconRed=FontAwesomeIcons.facebook;
          }else{
            iconRed=FontAwesomeIcons.instagram;
          }
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: 320.0,
                  height: 265.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: <Widget>[
                            Text(list[position].page.pageType.tipo),

                            Icon(
                              iconRed, color: Colors.grey,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap:() => Navigator.of(context).pushNamed('/post_detail',arguments: list[position]),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            Center(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Image.network(list[position].urlImagen,
                                height: 215,
                                fit:BoxFit.fill),
                            ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text("${list[position]
                                  .fecha.toString()} ",
                                style: TextStyle(
                                    color: Colors.grey),),
                            ),
                             Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 4.0),
                              child: Text(
                                "${list[position].page.nombre}",
                                style: TextStyle(fontSize: 20.0),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Comentarios: ${list[position].comments}",style: TextStyle(color: Colors.grey,fontSize:13 ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),

                                child: Text("Compartidos: ${list[position].shared}",style: TextStyle(color: Colors.grey,fontSize: 13)),
                              ),
                            ],),
                          Row(children: <Widget>[
                            IconButton(icon: Icon(Icons.delete), onPressed: ()=>dislikePost(list[position]))]),


                          ],
                        ),),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            onHorizontalDragEnd: (details) {
              animationController = AnimationController(vsync: this,
                  duration: Duration(milliseconds: 300));
              curvedAnimation = CurvedAnimation(
                  parent: animationController,
                  curve: Curves.fastOutSlowIn);
              animationController.addListener(() {
                setState(() {
                  currentColor =
                      colorTween.evaluate(curvedAnimation);
                });
              });

              if (details.velocity.pixelsPerSecond.dx > 0) {
                if (cardIndex > 0) {
                  cardIndex--;
                  colorTween = ColorTween(begin: currentColor,
                      end: appColors[new Random().nextInt(4)]);
                }
              } else {
                if (cardIndex < list.length) {
                  cardIndex++;
                  colorTween = ColorTween(begin: currentColor,

                      end: appColors[new Random().nextInt(4)]);
                }
              }
              setState(() {
                scrollController.animateTo((cardIndex) * 325.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              });

              colorTween.animate(curvedAnimation);

              animationController.forward();
            },
          );
        },
      ),
    );
  }

  void filterByContain(String contain)async{

    List<Post> newPosts= await new ExpressConnection().getPostByContains(contain);
    setState(() {
      misComent = newPosts;
    });
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);

    Navigator.of(context).pop(); // close the drawer
  }
PageType selectedType;
  Widget renderSearchDropDown(){

    return Container(
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Theme(
              data: ThemeData(canvasColor: Colors.black54, textTheme: TextTheme(body1: TextStyle(color: Colors.white70,fontSize: 16)) ),
              child:new DropdownButton<PageType>(
                  value: selectedType,
                  elevation: 8,
                  hint: Text(' Tipo... ',style: TextStyle(color: Colors.white70,fontSize: 16),),
                  items: tipos.map((PageType value) {
                    return  new DropdownMenuItem<PageType>(
                      value: value,
                      child:  new Text(value.tipo,style: TextStyle(color: Colors.white70,fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (PageType newValue) {
                    setState(() {
                      selectedType = newValue;
                      misComent=findByPageType(ExpressConnection.currentPublicaciones, selectedType.tipo);
                    });
                  }
              ),
            ),
          ],),

      );

  }

  Widget renderFilterText(){
    return(Container(

      child: Row(children: <Widget>[
       // Icon( Icons.search, size: 35.0, color: Colors.white),
        Theme(
          data: ThemeData(canvasColor: Colors.black54, textTheme: TextTheme(body1: TextStyle(color: Colors.white70,fontSize: 16)) ),
        child:  SizedBox(
          width: 220,
          child:  TextFormField(
              controller: filterController,

              style: new TextStyle(color: Colors.white70,fontSize: 16),
              decoration: InputDecoration(hintText: '  ¿Qué estas buscando?...',hintStyle: new TextStyle(color: Colors.white70)
              )
          ),

        ),),
          Padding(
            padding:EdgeInsets.only(left: 1),
            child: ButtonTheme(minWidth: 40,
              child: RaisedButton(
                onPressed: ()=>filterByContain(filterController.text),
                child:Icon(Icons.search,size: 30,color: Colors.white),splashColor: Colors.black12,elevation: 8,
          color: Colors.grey,),),),




        ],
      )));
  }





  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];

    return new Scaffold(
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(ExpressConnection.currentUser.persona.nombre),
              accountEmail: new Text(ExpressConnection.currentUser.persona.correo),
            ),
            new Column(children: drawerOptions),

          ],
        ),
      ),
      backgroundColor: currentColor,

      body: new Center(

        child: new SingleChildScrollView(child:  Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 34.0, vertical: 1.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                      child: Text(ExpressConnection.currentUser.persona.nombre, style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      child: Text("Bienvenido a KnowyBot, mira estas publicaciones.",
                      style: TextStyle(color: Colors.white),),),
                    renderFilterText(),
                    renderSearchDropDown(),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                renderPostCard(commentsScrollController,misComent),
              ],
            )
          ],
        ),),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}