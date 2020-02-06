import 'Page.dart';

class Post{
  String texto;
  DateTime fecha;
  String urlImagen;
  Page page;
  String idBd;
  String comments;
  String shared;

  Post();

  Post.values(this.texto, this.fecha, this.urlImagen, this.page);
  Post.valuesWithId(this.idBd,this.texto, this.fecha, this.urlImagen, this.page, this.comments, this.shared);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Post &&
              runtimeType == other.runtimeType &&
              idBd == other.idBd;

  @override
  int get hashCode => idBd.hashCode;



}