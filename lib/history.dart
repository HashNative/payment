import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment/services/services.dart';

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
        body: Container(
             child: FutureBuilder(
                 future: WebServices(this.mApiListener).getHistoryData(),
                 builder: (BuildContext context, AsyncSnapshot snapshot){
                   if (snapshot.data==null) {
                      return Container(
                        child: Center(
                          child: Text('Fetching data..'),
                        ),
                      );
                   } else {
                     return ListView.builder(
                       shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          isThreeLine: true,
                          leading: Text(snapshot.data[index].sender),
                          title: Text(snapshot.data[index].receiver),
                          subtitle: Text(snapshot.data[index].type),
                          trailing: Text(snapshot.data[index].amount),
                        );
                      },
                   );
                   }
                   
                   
                 },
               )
               
                )
            
    );
  }

}

