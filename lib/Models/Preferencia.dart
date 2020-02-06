import 'package:knowy_bot/Models/PageType.dart';

import 'Persona.dart';
import 'User.dart';

class Preferencia {
  String id;
  User user;
  Persona persona;
  PageType type;
  String ubicacion;
  String palabrasClave;

  Preferencia(this.id, this.user,this.persona, this.type, this.ubicacion,this.palabrasClave);


}