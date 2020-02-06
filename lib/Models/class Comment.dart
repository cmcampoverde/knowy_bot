import 'Post.dart';

class Comment {
  String nombre;
  String correo;
  String comment;
  String telefono;
  Post publicacion;

  Comment(this.nombre, this.correo, this.comment, this.telefono,
      this.publicacion);


}