import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/Persona.dart';
import 'package:knowy_bot/Models/User.dart';
import 'package:knowy_bot/Models/class%20Comment.dart';
import 'package:knowy_bot/search_page.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

import 'Models/Page.dart';
import 'Models/PageType.dart';
import 'Models/Post.dart';
import 'Models/Recommendation.dart';
import 'login_page.dart';

class posibleClients_page extends StatefulWidget {

static User currentUser=ExpressConnection.currentUser;

@override
  _posibleClients_page createState() => _posibleClients_page();
}


class _posibleClients_page extends State<posibleClients_page>with TickerProviderStateMixin {
  List<Recommendation> misRecom=new List<Recommendation>();
  var appColors = [Color.fromRGBO(82, 82, 82, 1.0),Color.fromRGBO(111, 194, 173, 1.0),Color.fromRGBO(47, 79, 79, 1.0),Color.fromRGBO(64, 64, 64, 1.0),Color.fromRGBO(82, 82, 82, 1.0)];
  var cardIndex = 0;
  ScrollController commentsScrollController;
  ScrollController recomScrollController;
  var currentColor = Color.fromRGBO(82, 82, 82, 1.0);

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;
  @override
  void initState() {
    super.initState();
    commentsScrollController = new ScrollController();
    recomScrollController = new ScrollController();
    misRecom= ExpressConnection.clientsRecommended;
   /* if(ExpressConnection.currentUser.username=='cmcampoverde'){
      misRecom=[RecommendationPage.recommendations[0],RecommendationPage.recommendations[1],RecommendationPage.recommendations[2],RecommendationPage.recommendations[3],RecommendationPage.recommendations[4]];
    }
    else{
      misRecom=[RecommendationPage.recommendations[5],RecommendationPage.recommendations[3]];
    }

    */
  }


  Widget renderRecommendedCard(ScrollController scrollController, List<Recommendation> list){
    if(list==null){
      return SizedBox.shrink();
    }else
    if(list.isNotEmpty)
    return Container(
      height: 400.0,
      child: ListView.builder(
        itemCount: list.length,
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          var  iconRed=FontAwesomeIcons.facebook;
         /* var iconRed;
          if(list[position].post.page.redSocial=='Facebook'){
            iconRed=FontAwesomeIcons.facebook;
          }else{
            iconRed=FontAwesomeIcons.instagram;
          }*/
          String contacto ;
          if(list[position].person.correo.isNotEmpty && list[position].person.correo!="None"){
            contacto = list[position].person.correo;
          }else if(list[position].person.telefono.isNotEmpty  && list[position].person.telefono!="None")
            contacto = list[position].person.telefono;
          else contacto = "Sin información";

          return GestureDetector(
            onTap:()=> showReview(context,list[position]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: 300.0,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child:
                            Icon(iconRed, color: Colors.grey,)
                        ),
                        GestureDetector(
                          onTap:() => showReview(context, list[position]),
                          child:
                          Column(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 1, top: 20, bottom: 3),
                              child: Text(list[position].person.nombre,
                                style: TextStyle(fontSize: 22.0),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 1, top: 5, bottom: 3),
                              child: Text("${contacto}",textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey),),
                            ),
                          ]
                          ),

                        ),
                      ],),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                          value: list[position].score),
                      ),
                       ],),),

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            onVerticalDragEnd:  (details) {
              animationController = AnimationController(vsync: this,
                  duration: Duration(milliseconds: 900));
              curvedAnimation = CurvedAnimation(
                  parent: animationController,
                  curve: Curves.fastOutSlowIn);
              animationController.addListener(() {
                setState(() {
                  currentColor =
                      colorTween.evaluate(curvedAnimation);
                });
              });

                  colorTween = ColorTween(begin: currentColor,
                      end: appColors[new Random().nextInt(2)]);
              setState(() {
                scrollController.animateTo((cardIndex) * 80.0,
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
    else  return SizedBox.shrink();
  }


  Future<bool> showReview(context, Recommendation review) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 350.0,
                  width: 200.0,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 150.0),
                          Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                color: Colors.teal),
                          ),
                          Positioned(
                              top: 50.0,
                              left: 94.0,
                              child: Container(
                                height: 120.0,
                                width:120.0,
                                child: RoundedLetter(
                                  shapeSize: 90,
                                  text: review.person.nombre.substring(0,1).toUpperCase(),
                                  fontSize: 30,
                                  shapeColor: Color.fromARGB(255, 215, 215, 215),
                                  shapeType: ShapeType.circle,
                                  borderColor: Color.fromARGB(255, 216, 216, 216),
                                  borderWidth: 2,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                          padding: EdgeInsets.only(left:50.0,top: 20.0,right: 50.0),
                          child: Text(
                            review.person.nombre,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            review.person.correo,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                                color: Colors.grey
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            review.person.telefono,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey
                            ),
                          )),
                      SizedBox(height: 15.0),
                      FlatButton(
                          child: Center(
                            child: Text(
                              'OKAY',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  color: Colors.teal),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.transparent
                      )
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currentColor,

      body: new Center(

        child: new SingleChildScrollView(child:  Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 5.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 5.0),
                      child: Text("Mira!", style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 5.0),
                      child: Text("Tus posblies clientes...", style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 64.0, vertical: 16.0),
                  child: Text("Hoy : ENE 21, 2020",
                    style: TextStyle(color: Colors.white),),
                ),
                renderRecommendedCard(recomScrollController,misRecom),
              ],
            )
          ],
        ),),
      ),
    );
  }
}