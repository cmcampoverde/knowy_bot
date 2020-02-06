
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/PageType.dart';
import 'package:knowy_bot/recommendation_page.dart';
import 'Models/Page.dart';
import 'Models/Post.dart';




class SearchPage extends StatefulWidget {

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
   final List<Post> posts=ExpressConnection.currentPublicaciones;

  static List<Post> postsFiltered;

  @override
  void initState(){
    super.initState();
    setState(() {
      postsFiltered = posts;
    });
  }

  Widget renderDataPost(Post post, IconData redSocial){
    return Container(
      child: Column(
          children: <Widget>[
           Padding(
           padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
            child: Row(children: <Widget>[
            Flexible(child:
             Text(post.page.nombre, style: new TextStyle(fontSize: 25.0),)
             ),
            ],
            ),
    ),
             Padding(
               padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                child: Row(children: <Widget>[
                  Text('19/01/2020'),Spacer()
               ],),
              ),
            Padding(
             padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
             child: Row(children: <Widget>[
            Icon(redSocial,color: Color(0xffe3b5998),),
             Text(post.page.redSocial, style: new TextStyle(fontSize: 20.0)),
              ],),
            ),
    ]
    )
    );
  }

   Widget renderPostCard(BuildContext context, int index){

     final post=posts[index];
     var red;
     if(post.page.redSocial.compareTo('Facebook')==0){
       red=FontAwesomeIcons.facebook;
     }else if(post.page.redSocial.compareTo('Instagram')==0){
       red=FontAwesomeIcons.instagram;
     }
     return Container(

       child: Card(
         child:Row(
         children:[
           Flexible(
              child: renderDataPost(post, red),
           ),
           Image.network(post.urlImagen,
           height: 125,
             fit:BoxFit.fill,),
         ],
         ),
       ),
     );
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
       body: SingleChildScrollView(child:
       Container(
          child:Column(
              children:<Widget>[
                  new TextField(decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      hintText: 'Busca tu preferencia'
                  ),
                    onChanged: (string){
                      setState(() {
                        postsFiltered = posts.where((p)=>
                        (p.page.nombre.toLowerCase().contains(string.toLowerCase())||
                            p.texto.toLowerCase().contains(string.toLowerCase()))).toList();
                      });
                    },
               ),
                new ListView.builder(
            shrinkWrap: true,
            itemCount: postsFiltered.length,
            itemBuilder:(BuildContext context,int index)=> renderPostCard(context, index),
        ),

    ]),
      ),
    ),
    );
  }
}