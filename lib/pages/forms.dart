import 'package:basicobdatos/datatype/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Formulario extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyForm();
  }
}
class _MyForm extends State<Formulario>{
  final _controladorCiudad = TextEditingController();
  final _controladorTemperatura = TextEditingController();
  final _controladorCondicion = TextEditingController();
  final _controladorIcon = TextEditingController();
  //final _controladorImagen = TextEditingController();

  Data data = Data("", "", "", "", "","");
  List<Data> _datos = [];

  Future<void> guardarDatos(String ciudad, String temperatura,String condicion, String icon, String imagen) async{
    try{
      await FirebaseFirestore.instance.collection('clima').add({
        'ciudad' : ciudad,
        'temperatura' : temperatura,
        'condicion' : condicion,
        'icon' : icon,
        'imagen' : imagen
      });
    }catch(e){
      print('Error al guardar datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro del clima"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorCiudad,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Ciudad"
              ),
            ),
            Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorTemperatura,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Temperatura"
              ),
            ),
            Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorCondicion,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Condición"
              ),
            ),
            Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorIcon,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Icono(Ejemplo: ☁ )"
              ),
            ),
            Padding(padding: EdgeInsets.all(20.0)),
            ElevatedButton(onPressed: (){
              if(validarNombre(_controladorCiudad.text)){
                data.ciudad = _controladorCiudad.text;
                data.temperatura= _controladorTemperatura.text;
                data.condicion = _controladorCondicion.text;
                data.icon = _controladorIcon.text;
                data.imagen = Data.downloadURL;
                setState(() {
                  guardarDatos(data.ciudad, data.temperatura,data.condicion, data.icon, data.imagen)
                      .then((_){
                    Navigator.pop(context);
                  })
                      .catchError((error){
                    alerta(context, "Error al guardar datos");
                  });
                });
              } else {
                alerta(context,'verifique la informacion ingresada');
              }
            },
                child: Text("Enviar")
            )
          ],
        ),
      ),
    );
  }
}

bool validarNombre(String cadena){
  RegExp exp = RegExp(r'^[a-zA-Z\s]+$');
  if(cadena.isEmpty){
    return false;
  } else if(!exp.hasMatch(cadena)) {
    return false;
  } else {
    return true;
  }
}

void alerta(BuildContext context,String mensaje){
  showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('¡Alerta!'),
          content: Text(mensaje),
          actions: <Widget>[
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }
                , child: Text("ok")
            ),
          ],
        );
      }
  );
}