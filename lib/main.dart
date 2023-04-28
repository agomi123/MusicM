import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:musicm/screens/Home.dart';
import 'package:musicm/screens/authentication.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'MusicM',
      theme: ThemeData(
       //fontFamily: 'regular',
       appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(0, 246, 238, 238),
        elevation: 0,
       )
      ),
      home: const HomeScreen(),
    );
  }
}
