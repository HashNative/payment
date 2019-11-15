

import 'package:payment/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:payment/home.dart';

class UpdateAmount extends StatelessWidget  {
  final String mobileNumber;
  final String userId;
  final ApiListener mApiListener;
  
  UpdateAmount(this.mobileNumber,this.userId, this.mApiListener);
  @override
  
@override
Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.black.withOpacity(0.6), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
     body: 
     
     Center(
             child: FutureBuilder<String>(
                  future: WebServices(this.mApiListener).updateAmount(this.mobileNumber,this.userId,'+94777140803'),
                  builder: (context,snapshot){
                    
                   
                  if (snapshot.data!=null) {
                     
                     return Center(
                         
                          child: SingleChildScrollView(
                         
                         child: Column(
                           children: <Widget>[
                            Text('${snapshot.data}', style: TextStyle(fontFamily: "Exo2",color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20.0),
                            RaisedButton(
                              onPressed: (){
                                  Navigator.pop(context);
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
                                     Home()
                                     ));
                              },
                              child: Text('Okay'),
                            ),
                         
                          ],
                         ),
                      
                          )
                       );
                     
              


                   }
                   if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                   }
                 return SpinKitPulse(
                   color: Colors.white,
                   size: 120.0,
                 );


                  },
                )
  
           
     ),
     
    
  );
 }

 
}
