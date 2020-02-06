import 'PageType.dart';

class Page {

  String id;
  String nombre;
  String direccion;
  PageType pageType;
  String telefono;
  String redSocial;
  String url;
  double taskCompletion;

  Page(this.id,this.nombre, this.direccion, this.pageType, this.telefono, this.redSocial,
      this.url,this.taskCompletion);

  Page.data(this.id,this.nombre, this.direccion, this.pageType, this.telefono, this.redSocial,
      this.url);


}