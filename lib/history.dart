import 'package:flutter/material.dart';


class History extends StatefulWidget {
  
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<History> {


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
                
                ],
            ),
          ),
                )
            
    );
  }

}
