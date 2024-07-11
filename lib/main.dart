import 'package:flutter/material.dart';
import 'package:integration1/screen/intg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Intg(),debugShowCheckedModeBanner: false,);
  }
}
