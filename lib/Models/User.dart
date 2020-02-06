import 'Persona.dart';

class User{
   String id;
   Persona persona;
   String username;
   String password;
   String correo;


  User(this.id,this.persona,this.username, this.password,this.correo);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        persona = json['persona'],
        username = json['username'],
        password= json['password'],
        correo = json['correo'];
}