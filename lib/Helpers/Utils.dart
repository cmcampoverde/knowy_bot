import 'dart:math';

import 'package:knowy_bot/Connection/ExpressConnection.dart';
import 'package:knowy_bot/Models/Post.dart';

class Utils{

  static List<Post> randomPosts= new List<Post>() ;

  static List<Post> selectRandomPost() {
    List<Post> posts=ExpressConnection.currentPublicaciones;
    if(ExpressConnection.currentPublicaciones == null)return new List<Post>();
    int numPost=10;
    List<int> elegidos=new List<int>();

    List<Post> selectedByTypes=new List<Post>();
    List<Post> randoms=new List<Post>();
    int r;
    bool repetido=false;
    for(int i=0;i<posts.length;i++) {
      if(ExpressConnection.currentMyTypes.contains(posts.elementAt(i).page.pageType))
        if(!ExpressConnection.currentMyDislikePosts.contains(posts.elementAt(i)))
        selectedByTypes.add(posts.elementAt(i));
    }
    if(selectedByTypes.length<4){
      randomPosts=selectedByTypes;
      return selectedByTypes;
    }else
    for(int i=0;i<numPost;i++){

    }
    randomPosts=randoms;
    return randoms;
  }

  static Future<bool> prepararData()async{
    ExpressConnection expressConnection=new ExpressConnection();
    await expressConnection.getPagesTypes();
    await expressConnection.getPages();
    await expressConnection.getPersonas();
    await expressConnection.getUsers();
    await expressConnection.getPostsList();
    return true;
  }
}