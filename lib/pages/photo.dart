import 'dart:io';
import 'package:basicobdatos/datatype/data.dart';
import 'package:basicobdatos/pages/forms.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Photo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyPhoto();
  }
}

class _MyPhoto extends State <Photo>{
  File? imageFile;
  final picker = ImagePicker();
  String downloadURL = "";
  Widget mostrarImagen(){
    return imageFile != null
        ? Image.file(imageFile!, width: 500, height: 500,)
        :const Text("Seleccione Una imágen"); //Si la imagen existe, toma la imagen con un tamaño de 500 x 500 y sino entonces pide que se seleccione una imagen
  }
  Future <void> enviarImagen() async{
    if (imageFile == null) return;
    try{
      String nomfoto = DateFormat.yMd().add_Hms().format(DateTime.now());
      String reffoto = "ciudad/" + nomfoto.replaceAll(RegExp(r'[\/ :]+'), "_");

      //Referencia a Firebase Storage
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('$reffoto.png');

      await ref.putFile(imageFile!);

      String url = await ref.getDownloadURL();
      setState(() {
        Data.downloadURL = url;
      });
      print("----------->$Data.downloadURL");

      Navigator.push(context, MaterialPageRoute( builder: (context) { // ✅ Se usa correctamente una función anónima
        return Formulario();
      },),);

    } catch (e){
      print("Error al subir la imagen $e");
    }
  }
  Future <void> showSelectionDialog(BuildContext context) async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              title:  const Text("Seleccione opción para foto"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Galeria"),
                      onTap: (){
                        seleccionarImagen(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      child:  const Text("Camara"),
                      onTap: (){
                        seleccionarImagen(ImageSource.camera);
                      },
                    )
                  ],
                ),
              )
          );
        }
    );

  }

  Future<void> seleccionarImagen(ImageSource source) async{
    try{
      final picture = await picker.pickImage(source: source);
      if(picture !=null){
        setState(() {
          imageFile = File(picture.path);
        });
      }
    }catch(e){
      print("Error al seleccionar la imagen: $e");
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(30)),
            Expanded(child: mostrarImagen()),
            SizedBox(height: 30),
            IconButton(
                onPressed: enviarImagen,
                icon: Icon(Icons.send)
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showSelectionDialog(context);
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}