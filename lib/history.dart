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
               FutureBuilder(
                 future: getHistoryData(),
                 builder: (BuildContext context, AsyncSnapshot snapshot){
                   
                   return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: Text(snapshot.data[index].sender),
                        );
                      },
                   );
                 },
               )
                ],
            ),
          ),
                )
            
    );
  }

}

