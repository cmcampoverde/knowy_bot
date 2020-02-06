


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:knowy_bot/Helpers/Utils.dart';
import 'package:knowy_bot/Models/Page.dart';
import 'package:knowy_bot/Models/PageType.dart';
import 'package:knowy_bot/Models/Persona.dart';
import 'package:knowy_bot/Models/Post.dart';
import 'package:knowy_bot/Models/Recommendation.dart';
import 'package:knowy_bot/Models/User.dart';
import 'package:mongo_dart/mongo_dart.dart';

class FirebaseConnection{

  static User currentUser;
  static List<PageType> currentTypes;
  static List<Post> currentPosts;
  static List<Page> currentPages;
  static List<Recommendation> currentRecomendations;
  static List<Recommendation> clientsRecommended;

  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        fontSize: 16.0);
  }

  Future<void> addDataToFirebase() async{
    var collection = 'tipos';
    var k=[
      {"_id":  "5e21436574b6931d9c888c23", "tipo": "Inmobiliaria"}, {"_id":  "5e2157a98c0b61ee77647423", "tipo": "Constructora"}, {"_id":  "5e23f73cd76888e31239ee3b", "tipo": "Automoviles"}, {"_id":  "5e25a71605e4c56c3eb7aad8", "tipo": "Seguros"}    ];
    for (int i=0;i<k.length;i++){
      var stringMap = Map<String, dynamic>.from(k[i]);
      Firestore.instance.collection(collection).add(stringMap).catchError((e){
        print(e);
      });
    }
  }

  Future <List<Post>> getPosts(){
    Firestore.instance.collection('publicaciones').getDocuments().then((onValue){
      print(onValue);
    });
  }

  Future <bool> authenticateUser(String username,String password)async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection('usuarios').getDocuments();

      List<DocumentSnapshot>users= querySnapshot.documents;
      for(int i=0;i<users.length;i++){
        var u=users.elementAt(i);
        if(u['username']==username && u['password']==password){
          Persona person= await getPersonaById(u['persona']);
            User userFounded= new User(u['_id'], person,u['username'],u['password'],person.correo);
            currentUser = userFounded;
            return true;
          }
        }
      return false;
      }

  Future <Persona> getPersonaById(String id)async{
    QuerySnapshot querySnapshot =await Firestore.instance.collection('personas').getDocuments();
    List<DocumentSnapshot>personas= querySnapshot.documents;
    for(int i=0;i<personas.length;i++){
      var p=personas.elementAt(i);
      if(p['_id']==id){
        Persona personaFounded= new Persona(p['id'],p['_id'], p['nombre'],p['correo'],p['telefono']);
        return personaFounded;
      }
    }
    return null;
  }

  Future <List<Recommendation>> getPersonasByRecommendations(User user)async{
    QuerySnapshot querySnapshot =await Firestore.instance.collection('recommendations').getDocuments();
    List<DocumentSnapshot>recomendaciones= querySnapshot.documents;
    List<Recommendation> clientesRecomendados=new List<Recommendation>();
    Persona personaRecomendada;
    Recommendation recommendation;

    for(int i=0;i<recomendaciones.length;i++){
      var p=recomendaciones.elementAt(i);
      if(p['id_usuario']==user.id){
        personaRecomendada = await getPersonaById(p['id_persona']);
        recommendation = new Recommendation();
        recommendation.person = personaRecomendada;
        recommendation.score = p['score'];
        recommendation.user = user;
        clientesRecomendados.add(recommendation);
      }
    }
    clientsRecommended=clientesRecomendados;
    return clientesRecomendados;
  }


  Future <Page> getPageaById(String id)async{
    QuerySnapshot querySnapshot =await Firestore.instance.collection('paginas').getDocuments();
    List<DocumentSnapshot>paginas= querySnapshot.documents;
    Page personaFounded;
    for(int i=0;i<paginas.length;i++){
      var p=paginas.elementAt(i);
      if(p['_id']==id){
        Page personaFounded= new Page.data(p['_id'],p['pagina'], p['direccion'], await getTipoById(p['tipo']), p['telefono'], p['redSocial'], p['url']);
        return personaFounded;
      }
    }
    return null;
  }

  Future <PageType> getTipoById(String id)async{
    QuerySnapshot querySnapshot =await Firestore.instance.collection('tipos').getDocuments();
    List<DocumentSnapshot>tipos= querySnapshot.documents;
    PageType typeFounded;
    for(int i=0;i<tipos.length;i++){
      var p=tipos.elementAt(i);
      if(p['_id']==id){
        typeFounded= new PageType.tipo(p['tipo']);
        return typeFounded;
      }
    }
    return null;
  }

  Future <bool> createUser(User user)async{


    Map<String,dynamic>  m = {"_id":user.id, "persona":user.persona.idBd,"username":user.username,"password":user.password,'correo':user.persona.correo};
    await Firestore.instance.collection('usuarios').add(m).catchError((e){
      print(e);
      return false;
    });
    return true;
  }

  Future <bool> createPersona(Persona persona)async{
    Map<String,dynamic> m = {"_id":persona.id, "nombre":persona.nombre,"correo":persona.correo,"telefono":persona.telefono};
    DocumentReference reference= await Firestore.instance.collection('personas').add(m).catchError((e){
      print(e);
      return false;
    });
    return true;
  }

  Future <bool> createUserValidando(User user)async{
    List<User> users = await getUsers();
    List<Persona> personas = await getPersonas();
    User us= users.first;
    for(int i=0;i<users.length;i++){
      us= users.elementAt(i);
      if(us.username==user.username){
        showToast('Ya existe este username');
        return false;
      }else if( us.correo==user.correo){
        showToast('Ya existe esta cuenta de Correo registrada');
        return false;
      }
    }
    Persona p;
    for(int i=0;i<personas.length;i++) {
      p = personas.elementAt(i);
      if (p.correo == user.persona.correo) {
        user.persona.idBd=p.idBd;
        updateUserData(p.id, user.persona);
        createUser(user);
        currentUser=user;
        showToast("Usuario creado");
        return true;
      }
    }
        createPersona(user.persona);
        createUser(user);
        currentUser=user;
      showToast("Usuario creado con éxito");
        return true;
}


  Future <List<User>> getUsers() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection('usuarios').getDocuments();

    List<DocumentSnapshot>users= querySnapshot.documents;
    List<User>usersList=new List<User>();
    for(int i=0;i<users.length;i++){
      var u=users.elementAt(i);
      Persona person= await getPersonaById(u['persona']);
      User userFounded= new User(u['_id'], person,u['username'],u['password'],u['correo']);
      usersList.add(userFounded);
    }
    return usersList;
  }


  Future <List<Persona>> getPersonas() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection('personas').getDocuments();

    List<DocumentSnapshot>personas= querySnapshot.documents;
    List<Persona>personsList=new List<Persona>();
    Persona personFounded;
    for(int i=0;i<personas.length;i++){
      var u=personas.elementAt(i);
      Persona personFounded= new Persona(u.documentID,u['_id'],u['nombre'],u['correo'],u['telefono']);
      personsList.add(personFounded);
    }
    return personsList;
  }

  Future<bool> updateUserData(String id, Persona persona)async{
    Map<String,dynamic> m = {"_id":persona.idBd, "nombre":persona.nombre,"correo":persona.correo,"telefono":persona.telefono};
   try {
     await Firestore.instance.collection('personas').document(id).setData(m);
     return true;
   }on Exception catch(ex){
     print(ex);
     return false;
   }
   }


  Future <List<Page>> getPages()async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection('paginas').getDocuments();

    List<DocumentSnapshot>paginas= querySnapshot.documents;
    List<Page>pageList=new List<Page>();
    Page page;
    for(int i=0;i<paginas.length;i++){
      var p=paginas.elementAt(i);
      page = new Page.data(p['_id'],p['pagina'], p['direccion'], await getTipoById(p['tipo']), p['telefono'], p['persona'], p['url']);
      pageList.add(page);
    }
    currentPages = pageList;
    return pageList;
  }

  Future<Post>getPostById(String idBd)async{
    List<Post>posts=await getPostsList();
    for(int i=0;i<posts.length;i++){
      if(posts.elementAt(i).idBd==idBd){
        return posts.elementAt(i);
      }
    }
    return null;
  }

  Future <List<Recommendation>> getRecomendations()async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection('recomendaciones').getDocuments();

    List<DocumentSnapshot>reco= querySnapshot.documents;
    List<Recommendation>recoList=new List<Recommendation>();
    Recommendation recommendation;
    for(int i=0;i<reco.length;i++){
      var p=reco.elementAt(i);
      if(p['id_persona']==currentUser.persona.idBd){
        recommendation = new Recommendation.values(currentUser, await getPostById(p['id_publicacion']),double.parse(p['score']));
        recoList.add(recommendation);
      }
    }
    currentRecomendations = recoList;
    return recoList;
  }

  Future<User>getUserByPerson(Persona p)async{
    List<User>users=await getUsers();
    for(int i=0;i<users.length;i++){
      if(users.elementAt(i).persona.idBd==p.idBd)
        return users.elementAt(i);
    }
    return null;
  }

  Future <List<PageType>> getPagesTypes()async{
     QuerySnapshot querySnapshot = await Firestore.instance.collection('tipos').getDocuments();

     List<DocumentSnapshot>tipos= querySnapshot.documents;
     List<PageType>pageTypeList=new List<PageType>();
     PageType pageType;
     for(int i=0;i<tipos.length;i++){
       var u=tipos.elementAt(i);
       pageType= new PageType(u['_id'],u['tipo']);
       pageTypeList.add(pageType);
     }
     currentTypes = pageTypeList;
     return pageTypeList;
   }


  Future <List<Post>> getPostsList()async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection('publicaciones').getDocuments();
    List<Page>pages=await getPages();
    List<DocumentSnapshot>posts= querySnapshot.documents;
    List<Post>postsList=new List<Post>();
    Post post;
    for(int i=0;i<posts.length;i++){
      var u=posts.elementAt(i);
      post= new Post.valuesWithId(u['_id'],u['texto'], DateTime.parse(u['fecha']), u['imagenes'], await getPageaById(u['pagina']),u['comentarios'],u['compartidos']);
      postsList.add(post);
    }
    currentPosts = postsList;
    Utils.selectRandomPost();

    return postsList;
  }

  Future<bool>savePreferencias( List<Map<String,String>> preferencias)async{
    try {
      for (int i = 0; i < preferencias.length; i++) {
        Firestore.instance.collection("preferencias").add(
            preferencias.elementAt(i)).catchError((e) {
          print(e);
        });
      }
      getRecomendations();
      getPersonasByRecommendations(currentUser);
      return true;
    }on Exception catch(e){
      print(e);
      return false;
    }
  }
}



