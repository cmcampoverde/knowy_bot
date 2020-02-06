


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

import 'Connection/ExpressConnection.dart';
import 'Models/Comentario.dart';
import 'Models/Post.dart';
import 'Models/Recommendation.dart';
import 'Models/User.dart';

class DetailPage extends StatefulWidget {

  static User currentUser=ExpressConnection.currentUser;

  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage>with TickerProviderStateMixin {
  List<Recommendation> misRecom=new List<Recommendation>();
  var appColors = [Color.fromRGBO(82, 82, 82, 1.0),Color.fromRGBO(111, 194, 173, 1.0),Color.fromRGBO(47, 79, 79, 1.0),Color.fromRGBO(64, 64, 64, 1.0),Color.fromRGBO(82, 82, 82, 1.0)];
  var cardIndex = 0;
  ScrollController commentsScrollController;
  ScrollController recomScrollController;
  var currentColor = Color.fromRGBO(82, 82, 82, 1.0);

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;

 // final Post post;

 // DetailPage(this.post);
//#region RenderListViewClients
  Widget renderRecommendedCard(ScrollController scrollController,Post post){

      return FutureBuilder<List<Comentario>>(
          future: _getComeentarios(post), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Comentario>> snapshot) {
            List<Comentario> list = snapshot.data;
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
                  if(list[position].persona.correo.isNotEmpty && list[position].persona.correo!="None"){
                    contacto = list[position].persona.correo;
                  }else if(list[position].persona.telefono.isNotEmpty  && list[position].persona.telefono!="None")
                    contacto = list[position].persona.telefono;
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
                                      child: Text(list[position].persona.nombre,
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
                                    value: 1),
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

          }
          );


  }


  Future<bool> showReview(context, Comentario review) {
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
                                  text: review.persona.nombre.substring(0,1).toUpperCase(),
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
                            review.persona.nombre,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            review.persona.correo,
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
                            review.persona.telefono,
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

//#endregion

  Future<List<Comentario>> _getComeentarios (Post postR)async {
   return await new ExpressConnection().getClientsByPost(postR.idBd);
  }

    @override
    void initState() {
      super.initState();
      commentsScrollController = new ScrollController();
      recomScrollController = new ScrollController();
     // final Post postR = ModalRoute.of(context).settings.arguments;

    }

    @override
    Widget build(BuildContext context) {
      final Post post = ModalRoute.of(context).settings.arguments;

      return new Scaffold(
        body: SingleChildScrollView(child: Container(color: Colors.white70 ,child: Column(children: <Widget>[
          Stack(

            children: <Widget>[
              Image.network(post.urlImagen),
              Positioned(
                top: 10.0,
                left: 10.0,
                right: 10.0,
                child: Opacity(
                  opacity: 0.7,
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16,bottom: 2),
                          child: Text(
                            post.page.redSocial,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1,bottom: 2),
                          child: Text(
                              post.page.pageType.tipo),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(post.page.nombre,textAlign: TextAlign.left ,style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,),),
          Text(post.fecha.toString(),textAlign: TextAlign.right ,style: TextStyle(
            fontSize: 16.0,
          ),),
          SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  child:   Padding(
                    padding: EdgeInsets.only(left: 16.0,top: 16.0,right: 16.0,bottom: 20.0),
                    child:  Text(post.texto
                    ),),

                ),),

                renderRecommendedCard(recomScrollController, post)
              ],),),
        ]),
        ),
        ),
      );
    }

}