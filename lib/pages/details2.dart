import 'package:basicobdatos/pages/cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:basicobdatos/datatype/data.dart';

class Details2 extends StatefulWidget {
  final Data data;
  Details2({required this.data});

  @override
  State<StatefulWidget> createState() {
    return _MyDetails();
  }
}

class _MyDetails extends State<Details2> {
  late TextEditingController ciudadController;
  late TextEditingController temperaturaController;
  late TextEditingController condicionController;
  late TextEditingController iconController;

  @override
  void initState() {
    super.initState();
    ciudadController = TextEditingController(text: widget.data.ciudad);
    temperaturaController = TextEditingController(text: widget.data.temperatura);
    condicionController = TextEditingController(text: widget.data.condicion);
    iconController = TextEditingController(text: widget.data.icon);
  }

  @override
  void dispose() {
    ciudadController.dispose();
    temperaturaController.dispose();
    condicionController.dispose();
    iconController.dispose();
    super.dispose();
  }

// Método para actualizar (usa widget.data.uID internamente)
  void actualizarDatos() async {
    try {
      await FirebaseFirestore.instance
          .collection('clima')
          .doc(widget.data.uID)
          .update({
        'ciudad': ciudadController.text,
        'temperatura': temperaturaController.text,
        'condicion': condicionController.text,
        'icon': iconController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Se ha actualizado correctamente'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context); // Regresa conservando la pila de navegación

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al actualizar: ${e.toString()}')),
      );
    }
  }


// Método para eliminar
  void eliminarDatos() async {
    try {
      // 1. Eliminar imagen (si aplica)
      if (widget.data.imagen.startsWith('gs://')) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(widget.data.imagen);
          await ref.delete();
          print('Imagen eliminada de Storage');
        } catch (storageError) {
          print('Error eliminando imagen: $storageError');
          throw Exception('No se pudo eliminar la imagen. ¿URL válida?');
        }
      }

      // 2. Eliminar documento
      if (widget.data.uID.isEmpty) {
        throw Exception('ID del documento inválido');
      }

      await FirebaseFirestore.instance
          .collection('clima')
          .doc(widget.data.uID)
          .delete();

      // 3. Feedback y redirección
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Datos e imagen eliminados'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Regresa conservando la pila de navegación

    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Error: ${e.code} - ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.blueGrey,
        title: Text(widget.data.ciudad, style: TextStyle(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 📌 Sección de la imagen con tamaño fijo
            Container(
              height: 250, // Ajustar tamaño de la imagen
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.data.imagen),
                  fit: BoxFit.cover, // Ajustar la imagen correctamente
                ),
              ),
            ),

            // 📌 Espaciado para evitar superposición
            SizedBox(height: 20),

            // 📌 Formulario de edición
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: ciudadController,
                    decoration: InputDecoration(labelText: "Ciudad"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: temperaturaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Temperatura"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: condicionController,
                    decoration: InputDecoration(labelText: "Condición"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: iconController,
                    decoration: InputDecoration(labelText: "Icono (Emoji)"),
                  ),
                  SizedBox(height: 20),

                  // 📌 Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: actualizarDatos,
                        child: Text("Actualizar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: eliminarDatos,
                        child: Text("Eliminar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),

                  // 📌 Espacio final para mejor visualización
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
