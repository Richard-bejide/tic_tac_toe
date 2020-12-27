import 'package:flutter/material.dart';
import 'home_page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'flutter app',
        home: HomePage(),
        theme: ThemeData(primaryColor: Colors.black));
  }
}

