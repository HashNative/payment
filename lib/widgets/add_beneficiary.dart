import 'package:payment/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:payment/home.dart';

class AddBeneficiary extends StatelessWidget {
  final String addedBy;
  final String name;
  final String mobile;
  final ApiListener mApiListener;

  AddBeneficiary(this.mobile, this.addedBy, this.mApiListener, this.name);
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
          0.6), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: Center(
          child: FutureBuilder<String>(
        future: WebServices(this.mApiListener).addBeneficiary(this.mobile,this.addedBy),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Center(
                child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('${snapshot.data}',
                      style: TextStyle(
                          fontFamily: "Exo2",
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home()));
                    },
                    child: Text('Okay'),
                  ),
                ],
              ),
            ));
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return SpinKitPulse(
            color: Colors.white,
            size: 120.0,
          );
        },
      )),
    );
  }
}
