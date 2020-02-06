
import 'Persona.dart';
import 'Post.dart';

class Comentario{
  String id;
  Persona persona;
  String comentario;
  Post publicacion;

  Comentario(this.id, this.persona, this.comentario, this.publicacion);


}