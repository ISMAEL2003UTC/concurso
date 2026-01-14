
import 'package:flutter/material.dart';

import 'views/menu_principal.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes :{
        '/': (context) => MenuScreen(),
        //'/provincias/form': (context) => (),
        //'/provincias': (context) =>  (),
  
      }
    );
  }
}