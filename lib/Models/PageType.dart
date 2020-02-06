class PageType{

  String id;
  String tipo;
  String palabrasClave;

  PageType.tipo(this.tipo);

  PageType(this.id, this.tipo);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PageType &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;



}