import 'package:crypto_currency_app/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cryptocurrency",
      theme: ThemeData(
        fontFamily: "Nunito",
        primarySwatch: Colors.pink
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

