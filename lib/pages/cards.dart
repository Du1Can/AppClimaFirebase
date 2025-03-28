import 'package:basicobdatos/datatype/data.dart';
import 'package:basicobdatos/pages/details.dart';
import 'package:basicobdatos/pages/details2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cards extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       title: Text("Datos del Clima"),
     ),
     body: StreamBuilder(
         stream: FirebaseFirestore.instance.collection('clima').snapshots(),
         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
           if(snapshot.connectionState == ConnectionState.waiting){
             return Center(
               child: CircularProgressIndicator(),
             );
           }
           if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
             return Center(
               child: Text('No hay datos disponibles'),
             );
           }
           var climacard = snapshot.data!.docs.map((doc){
             var data = doc.data() as Map<String, dynamic>;
             return Data(
               data['uID']=doc.id,
               data['ciudad']??"", //sino no tiene datos pone ""
               data['temperatura']??"",
               data['condicion']??"",
               data['icon']??"",
               data['imagen']??"",
             );

           }).toList();
           return ListView.builder(
               itemCount: climacard.length,
               itemBuilder: (context, index){
                var ciudad = climacard[index];
                return Card(
                  margin: EdgeInsets.all(7),
                  elevation:  5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(ciudad.imagen),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(ciudad.ciudad),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Temperatura: ${ciudad.temperatura}°C"),
                        Text("Condición: ${ciudad.icon} ${ciudad.condicion}"),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context){
                                  return Details2(data: ciudad);
                                }
                            )
                        );
                      },
                      child: Icon(Icons.info_outline),
                    )
                  ),
                );
               }
           );
         }
     ),
   );
  }

}