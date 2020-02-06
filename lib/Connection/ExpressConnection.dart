

import 'package:fluttertoast/fluttertoast.dart';
import 'package:knowy_bot/Connection/network_utils.dart';
import 'package:knowy_bot/Helpers/Utils.dart';
import 'package:knowy_bot/Models/Comentario.dart';
import 'package:knowy_bot/Models/Persona.dart';
import 'package:knowy_bot/Models/Preferencia.dart';
import 'package:knowy_bot/Models/SearchData.dart';
import 'package:knowy_bot/Models/User.dart';
import 'package:knowy_bot/Models/Recommendation.dart';
import 'package:knowy_bot/Models/Post.dart';
import 'package:knowy_bot/Models/Page.dart';
import 'package:knowy_bot/Models/PageType.dart';


class ExpressConnection{
  static User currentUser;
  static List<User> currentUsersList;
  static List<Persona> persons;
  static List<PageType> currentTypes;
  static List<PageType> currentMyTypes;
  static List<Post> currentPublicaciones;
  static List<Post> currentMyDislikePosts;
  static List<Page> currentPages;
  static List<Recommendation> currentRecomendations;
  static List<Recommendation> clientsRecommended;
  static List<Preferencia> currentPreferences;
  NetworkUtils net;

  ExpressConnection() {
    this.net = new NetworkUtils();
  }

  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        fontSize: 16.0);
  }

  Future <bool> authenticateUser(String username,String password)async{
    var users = await net.get('/usuarios');
    for(int i=0;i<users.length;i++){
      var u=users.elementAt(i);
      if(u['username']==username && u['password']==password){
        Persona person= await getPersonaById(u['persona']);
        User userFounded= new User(u['_id'], person,u['username'],u['password'],(person.correo!=null)?person.correo:'');
        currentUser = userFounded;
        return true;
      }
    }
    return false;
  }

  //# region GETs All
  Future <List<Persona>> getPersonas() async {
    var personas= await net.get('/personas');
    List<Persona>personsList=new List<Persona>();
    for(int i=0;i<personas.length;i++){
      var u=personas.elementAt(i);
      Persona personFounded= new Persona(u['_id'],u['_id'],u['nombre'],u['correo'],u['telefono']);
      personsList.add(personFounded);
    }
    persons = personsList;
    return personsList;
  }

  Future <List<Recommendation>> getRecomendations()async{
    var reco = await net.get('/recomendacion_ejemplo');
    List<Recommendation>recoList=new List<Recommendation>();
    Recommendation recommendation;
    for(int i=0;i<reco.length;i++){
      var p=reco.elementAt(i);
     // if(p['id_persona_usuario']==currentUser.persona.idBd){
      try {
        recommendation = new Recommendation.valuesWithPersons(
            await getPersonaById(p['id_persona_usuario']),
            await getPersonaById(p['id_persona_recomendada']),
            double.parse(p['score']));
        recoList.add(recommendation);
      }on Exception catch(e){
        print(e);
    }
    //  }
    }

    currentRecomendations = recoList;
    return recoList;
  }

  Future <List<Post>> getPostsList()async{
    var posts = await net.get('/publicaciones');
    List<Post>postsList=new List<Post>();
    Post post;
    for(int i=0;i<posts.length;i++){
      var u=posts.elementAt(i);
      post= new Post.valuesWithId(u['_id'],u['texto'], DateTime.parse(u['fecha']), u['imagenes'], getPagesById(u['pagina']),u['comentarios'],u['compartidos']);
      postsList.add(post);
    }
    currentPublicaciones = postsList;
    return postsList;
  }

  Future <List<Post>> getMyDislikePosts()async{
    var posts = await net.get('/publicacionesUsuario');
    List<Post>postsList=new List<Post>();
    Post post;
    for(int i=0;i<posts.length;i++){
      var u=posts.elementAt(i);
      if(u['id_usuario']==currentUser.id) {
        post = getPostById(u['id_publicacion']);
        postsList.add(post);
      }
    }
    currentMyDislikePosts= postsList;
     return postsList;
  }

  Future <List<User>> getUsers() async {
    var users = await net.get('/usuarios');
    List<User>usersList=new List<User>();
    for(int i=0;i<users.length;i++){
      var u=users.elementAt(i);
      Persona person=  getPersonaById(u['persona']);
      User userFounded= new User(u['_id'], person,u['username'],u['password'],u['correo']);
      usersList.add(userFounded);
    }
    currentUsersList = usersList;
    return usersList;
  }

  Future <List<Preferencia>> getPreferences() async {
    var preferencias = await net.get('/preferencias/misPreferencias/'+currentUser.id);
    List<Preferencia>preferencesList=new List<Preferencia>();
    for(int i=0;i<preferencias.length;i++){
      var p=preferencias.elementAt(i);
      Preferencia preferenciaFounded= new Preferencia(p['_id'], currentUser,currentUser.persona,await getTipoById(p['tipo']),p['palabrasClave'],p['ubicacion']);
      preferencesList.add(preferenciaFounded);
    }
    currentPreferences = preferencesList;
    //getMyPagesTypes();
    return preferencesList;
  }


  Future <List<Page>> getPages()async{
   var paginas = await net.get('paginas');
    List<Page>pageList=new List<Page>();
    Page page;
    for(int i=0;i<paginas.length;i++){
      var p=paginas.elementAt(i);
      page = new Page.data(p['_id'],p['pagina'], p['direccion'],getTipoById(p['tipo']), p['telefono'], p['redSocial'], p['url']);
      pageList.add(page);
    }
    currentPages = pageList;
    return pageList;
  }
  //#endregion




  //# region GETs By ...
  Future<User>getUserByPerson(Persona p)async{
    List<User>users=await getUsers();
    for(int i=0;i<users.length;i++){
      if(users.elementAt(i).persona.idBd==p.idBd)
        return users.elementAt(i);
    }
    return null;
  }

  Persona getPersonaById(String id){
    List<Persona> personas = persons;
    for(int i=0;i<personas.length;i++){
      var p=personas.elementAt(i);
      if(p.id==id){
        return p;
      }
    }
    return null;
  }

  Post getPostById(String idBd){
   // List<Post>posts=await getPostsList();
    List<Post>posts= currentPublicaciones;
    for(int i=0;i<posts.length;i++){
      if(posts.elementAt(i).idBd==idBd){
        return posts.elementAt(i);
      }
    }
    return null;
  }

  Page getPagesById(String id){
    List<Page> paginas = currentPages;
    Page page;
    for(int i=0;i<paginas.length;i++){
      Page p=paginas.elementAt(i);
      if(p.id==id){
        page= new Page.data(p.id,p.nombre, p.direccion, p.pageType, p.telefono, p.redSocial, p.url);
        return page;
      }
    }
    return null;
  }

  PageType getTipoById(String id){
    List<PageType> tipos = currentTypes;
    PageType type;
    for(int i=0;i<tipos.length;i++){
      type=tipos.elementAt(i);
      if(type.id==id){
        return type;
      }
    }
    return null;
  }

  Future <List<Comentario>>getClientsByPost(String idPost)async{
    var comentarios = await net.get('/comentarios/interesados/'+idPost);
    List<Comentario>commentsList=new List<Comentario>();
    Comentario comment;
    for(int i=0;i<comentarios.length;i++){
      var p=comentarios.elementAt(i);
      comment = new Comentario(p['_id'],getPersonaById(p["persona"]),p['comentario'],getPostById(p['publicacion']));
      commentsList.add(comment);
    }
    return commentsList;
  }

  Future <List<Recommendation>> getPersonasByRecommendations(User user)async{
    ///CUANDO LELGA AQUI AUN NO HAY RECOMENDACIONES, HAY QUE LLAMARLAS DESDE QUE SE PIDE EL LOGIN AUHETINCATE
    List<Recommendation> recomendaciones = currentRecomendations;
    List<Recommendation> clientesRecomendados=new List<Recommendation>();
    Persona personaRecomendada;
    Recommendation recommendation;

    for(int i=0;i<recomendaciones.length;i++){
      var p=recomendaciones.elementAt(i);
      if(p.person_u.id==user.persona.id){
        personaRecomendada = await getPersonaById(p.person.id);
        recommendation = new Recommendation();
        recommendation.person = personaRecomendada;
        recommendation.score = p.score;
        recommendation.user = user;
        clientesRecomendados.add(recommendation);
      }
    }
    clientsRecommended=clientesRecomendados;
    return clientesRecomendados;
  }

  Future <List<PageType>> getMyPagesTypes()async{
    if(currentPreferences==null)await getPreferences();
    List<PageType>pageTypeList=new List<PageType>();
    Preferencia preferencia;
    for(int i=0;i<currentPreferences.length;i++){
      preferencia=currentPreferences.elementAt(i);
      if(preferencia.type!=null)
      pageTypeList.add(preferencia.type);
    }
    currentMyTypes = pageTypeList;
    return pageTypeList;
  }

  Future <List<PageType>> getPagesTypes()async{
   var tipos = await net.get('/tipos');
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

  Future <List<Post>> getPostByContains(String contain)async{
    var posts = await net.get('/publicaciones/contains/'+contain);
    List<Post>postsList=new List<Post>();
    Post post;
    for(int i=0;i<posts.length;i++){
      var u=posts.elementAt(i);
      post=currentPublicaciones.firstWhere((post)=>(post.idBd==u['_id']));
      if(currentMyTypes.contains(post.page.pageType))
      postsList.add(post);
    }
    return postsList;
  }
  //# endregion

  // region Create
  Future <String> createUser(User user)async{
    Map<String,dynamic>  m = {"persona":user.persona.idBd,"username":user.username,"password":user.password,'correo':user.persona.correo};
    String jsonUser = "{\"persona\":\""+user.persona.idBd+"\",\"username\":\""+user.username+"\",\"password\":\""+user.password+"\",\"correo\":\""+user.persona.correo+"\"}";
    var response=await net.post('/usuarios',jsonBody:jsonUser);
    String id='';
    try {
      id= response['_id'];
    }on Exception catch(e){
      id='null';
    }
    return id;
  }

  Future <String> createPersona(Persona persona)async{
    Map<String,dynamic> m = { "nombre":persona.nombre,"correo":persona.correo,"telefono":persona.telefono};
    String jsonPersona = "{\"nombre\":\""+persona.nombre+"\",\"correo\":\""+persona.correo+"\",\"telefono\":\""+persona.telefono+"\"}";
    var response = await net.post('/personas',jsonBody:jsonPersona);
    String id= '';
    try {
     id= response['_id'];
    }on Exception catch(e){
      id='null';
    }
    return id;
  }

  Future <bool> createUserValidando(User user)async{
    List<User> users = await getUsers();
    List<Persona> personas = persons;
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
    String id=await createPersona(user.persona);
    if(id=='null')return false;
    user.persona.id=id;
    user.persona.idBd=id;
    String idU = await createUser(user);
    if(idU=='null')return false;
    user.id=idU;
    currentUser=user;
    showToast("Usuario creado con éxito");
    return true;
  }
  // endregion

  //#region Updates
  //REVISAR EL UPDATE Y TODOS LOS METODOS PERO SOBRE TODO ESTE UPDATE
  Future<bool> updateUserData(String id, Persona persona)async{
    Map<String,dynamic> m = {"_id":persona.idBd, "nombre":persona.nombre,"correo":persona.correo,"telefono":persona.telefono};
    try {
      net.update('/personas',body:persona);
      return true;
    }on Exception catch(ex){
      print(ex);
      return false;
    }
  }

  Future<bool>savePreferencias( List<Preferencia> preferencias)async{
    try {
Preferencia preferencia;
      for (int i = 0; i < preferencias.length; i++) {
        preferencia = preferencias.elementAt(i);
        String jsonPreferencia = "{\"id_persona\":\""+preferencia.persona.idBd+"\",\"id_usuario\":\""+preferencia.user.id+"\",\"tipoPagina\":\""+preferencia.type.id+"\",\"palabrasClave\":\""+preferencia.palabrasClave+"\",\"ubicacion\":\""+preferencia.ubicacion+"\"}";

        net.post('/preferencias',jsonBody: jsonPreferencia);
      }
      getRecomendations();
      getPersonasByRecommendations(currentUser);
      return true;
    }on Exception catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> dislakePost(Post post)async{
    try {
        String jsonPost = "{\"id_usuario\":\""+currentUser.id+"\",\"id_publicacion\":\""+post.idBd+"\"}";

        net.post('/publicacionesUsuario',jsonBody: jsonPost);
      return true;
    }on Exception catch(e){
      print(e);
      return false;
    }
  }
  //# endregion

  //# region AnotherServer
  Future<bool> sendToSearchComplete(SearchData data)async{
    try {
      String jsonData = "{\"red\":\""+data.red+"\",\"key\":\""+data.key+"\",\"tipo\":\""+data.tipo+"\",\"fec\":\""+data.fec+"\",\"pub\":"+data.pub.toString()+",\"pubcom\":"+data.pubcom.toString()+",\"num\":\""+data.num+"\",\"city\":\""+data.city+"\"}";
      //{"red":"face","key":"Inmobiliaria","tipo":"Inmobiliaria","fec":"10/16/2019","pub":false,"com":false,"pubcom":true,"num":"5","city":"Quito"}
      await net.post2("/general", body: jsonData);
      //net.postAnotherUrl('/general',jsonBody: jsonData);
      return true;
    }on Exception catch(e){
      print(e);
      return false;
    }
  }
  //# endregion
}