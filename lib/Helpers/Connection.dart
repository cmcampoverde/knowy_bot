
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;


class Connection {
  Db db;

  static Future getData() async{
    String ca='asdasd';
    String cnasa=ca;
    var url = 'mongodb://mineriaacm:Mineria2019@mineriacluster-shard-00-00-wri2f.mongodb.net:27017,mineriacluster-shard-00-01-wri2f.mongodb.net:27017,mineriacluster-shard-00-02-wri2f.mongodb.net:27017/mineria?ssl=true&replicaSet=MineriaCluster-shard-0&authSource=admin&retryWrites=true&w=majority';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data.toString());
  }

  Future getUsers() async {
    Db db = new Db("mongodb+srv://mineriaacm:Mineria2019@mineriacluster-wri2f.mongodb.net/test?retryWrites=true&w=majority");

    await db.open();
    DbCollection users=db.collection('usuario');

    users.find().forEach((v) => print(v));

  }

}