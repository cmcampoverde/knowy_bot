import 'Persona.dart';
import 'Post.dart';
import 'User.dart';

class Recommendation{

  User user;
  Post post;
  Persona person_u;
  Persona person;
  double score;
  Recommendation();
  Recommendation.values(this.user,this.post,this.score);
  Recommendation.valuesWithPersons(this.person_u,this.person,this.score);

}