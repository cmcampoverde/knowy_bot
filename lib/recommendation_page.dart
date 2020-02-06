import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/User.dart';
import 'package:knowy_bot/Models/class%20Comment.dart';
import 'package:knowy_bot/search_page.dart';

import 'Models/Page.dart';
import 'Models/PageType.dart';
import 'Models/Post.dart';
import 'Models/Recommendation.dart';
import 'login_page.dart';

class RecommendationPage extends StatefulWidget {


static User currentUser=ExpressConnection.currentUser;


@override
  _RecommendationPage createState() => _RecommendationPage();
}


class _RecommendationPage extends State<RecommendationPage>with TickerProviderStateMixin {
  List<Page> pages= ExpressConnection.currentPages;
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
    misRecom = ExpressConnection.currentRecomendations;
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
      height: 350.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          var iconRed;
          if(list[position].post.page.redSocial=='Facebook'){
            iconRed=FontAwesomeIcons.facebook;
          }else{
            iconRed=FontAwesomeIcons.instagram;
          }
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: 250.0,
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
                            Text(list[position].post.page.nombre),
                            Icon(
                              iconRed, color: Colors.grey,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap:() => Navigator.of(context).pushNamed('/post_detail',arguments: list[position].post),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            Center(child:
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Image.network(list[position].post.urlImagen,
                                height: 125,
                                fit:BoxFit.fill,),
                            ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text("${list[position]
                                  .post.texto.substring(0,20)}",
                                style: TextStyle(
                                    color: Colors.grey),),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                "${list[position].post.page.pageType.tipo}",
                                style: TextStyle(fontSize: 28.0),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LinearProgressIndicator(
                                value: list[position].score
                                    ,),
                            ),
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
                  duration: Duration(milliseconds: 500));
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
                      end: appColors[new Random().nextInt(2)]);
                }
              } else {
                if (cardIndex < list.length) {
                  cardIndex++;
                  colorTween = ColorTween(begin: currentColor,

                      end: appColors[new Random().nextInt(2)]);
                }
              }
              setState(() {
                scrollController.animateTo((cardIndex) * 256.0,
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


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currentColor,

      body: new Center(

        child: new SingleChildScrollView(child:  Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 10.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                      child: Text("Mira!", style: TextStyle(
                          fontSize: 34.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                      child: Text("Te recomendamos...", style: TextStyle(
                          fontSize: 30.0,
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