class Data{
  final String uID;
  late String ciudad;
  late String temperatura;
  late String condicion;
  late String icon;
  late String imagen;
  static String downloadURL = '';

  Data(
      this.uID,
      this.ciudad,
      this.temperatura,
      this.condicion,
      this.icon,
      this.imagen
      );

//late es para  decirle que despues inicializamos la variable.



}