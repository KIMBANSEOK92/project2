import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _colorName = 'No';
  Color _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text('Flutter Circular Menu'),
        ),
        body: CircularMenu(
          alignment: Alignment.center,
          radius: 200,
          toggleButtonColor: Colors.deepOrangeAccent,
          items: [
            CircularMenuItem(
              icon: Icons.home,
              onTap: () {},
              color: Colors.green[300],
            ),
            CircularMenuItem(
              icon: Icons.search,
              onTap: () {},
              color: Colors.blue[300],
            ),
            CircularMenuItem(
              icon: Icons.settings,
              onTap: () {},
              color: Colors.black,
            ),
            CircularMenuItem(
              icon: Icons.star,
              onTap: () {},
              color: Colors.yellow[500],
            ),
            CircularMenuItem(
              icon: Icons.pages,
              onTap: () {},
              color: Colors.brown[300],
            ),
          ],
        ),
      ),
    );
  }
}
