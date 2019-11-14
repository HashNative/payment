import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:payment/services/services.dart';
import 'dart:convert';


class History extends StatefulWidget {
  
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<History> {
ApiListener mApiListener;
 String userId;


   @override
  void initState() {

    FirebaseAuth.instance.currentUser().then((value){
       if (value!=null) {
       setState(() {
    this.userId=value.phoneNumber;
         });
       }
    });

    super.initState();
  
 
  
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Transaction History",
              style:
              TextStyle(fontFamily: "Exo2", color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: Center(
             child: SingleChildScrollView(
            child: Column(
             
              children: <Widget>[
               FutureBuilder<int>(
                 future: WebServices(this.mApiListener).updateAmount('10','+94770581168','+94777140803'),
                 builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                   if (snapshot.data!=null) {
                     return Text('data comes.');
                   }
                   if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                   }
                   return CircularProgressIndicator();
                 },
               )
                ],
            ),
          ),
                )
            
    );
  }

}

