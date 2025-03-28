import 'package:basicobdatos/pages/cards.dart';
import 'package:basicobdatos/pages/photo.dart';
import 'package:flutter/material.dart';

class Start extends StatefulWidget{ //En un stateful widget, es decir, uno que cambia de estado, es neesario hacer dos clases.
  @override
  State<StatefulWidget> createState(){ //Crea el estado inicial, en este caso de una clase.
    return _MyState();
  }
}
class _MyState extends State<Start>{ //Crea una clase del estado de la clase padre.
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    Photo(),
    Cards()
  ]; //Lista de páginas constante en tiempo de compilación.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    void _onItemTapped(int index){
      setState(() {
        _selectedIndex= index;
      });
    }
    return Scaffold(
      body: Center(
          child: _pages[_selectedIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.cyan[200],
          selectedItemColor: Colors.amber[500],
          unselectedItemColor: colorScheme.onSurface.withOpacity(.70),
          items: const<BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'Información'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Mapa'
            ),
          ]
      ),
    );
  }
}