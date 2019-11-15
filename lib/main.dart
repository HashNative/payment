import 'package:flutter/material.dart';
import 'package:payment/signin.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Signin()
      
      
      

    );
  }


  
}







