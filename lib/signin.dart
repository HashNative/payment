import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment/home.dart';
import'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:payment/services/webservices.dart';
import 'package:payment/services/apilistener.dart';

class Signin extends StatefulWidget {
  
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<Signin> {
 final TextEditingController amountController = TextEditingController();
 
 ApiListener mApiListener;
 String phoneNo;
 String smsCode;
 String verificationId;
 
 
 Future<void> verifyPhone() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId){
       this.verificationId = verId;
       smsCodeDialog(context);
      
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]){
       this.verificationId = verId;
       smsCodeDialog(context).then((value) {

         print('signed in');
       });

      
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential) {
       print('verified');
       Navigator.of(context).pop();
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
          Home()
        ));

    };
    final PhoneVerificationFailed veriFailed =(AuthException exception){
      print('${exception.message}');
    };
await FirebaseAuth.instance.verifyPhoneNumber(
   phoneNumber: this.phoneNo,
   codeAutoRetrievalTimeout: autoRetrive,
   codeSent: smsCodeSent,
   timeout: const Duration(seconds:5),
   verificationCompleted: verifiedSuccess,
   verificationFailed: veriFailed,
);
 } 

 Future<bool> smsCodeDialog(BuildContext context){
     return showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext contect){
         return new AlertDialog(
           title: Text('Enter SMS Code'),
           content: 
           new VerificationCodeInput(
            keyboardType: TextInputType.number,
            length: 6,
            onCompleted: (String value) {
              this.smsCode=value;
            },
           ),
           contentPadding: EdgeInsets.all(10.0),
           actions: <Widget>[
             new FlatButton(
               child: Text('Done'),
               onPressed: (){
               FirebaseAuth.instance.currentUser().then((user) {
                 if (user!=null) {
                   Navigator.of(context).pop();
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
                      Home()
                    ));
                 }else{
                   Navigator.of(context).pop();
                   signIn();
                 }
               });

               }
             )
           ],
         );
       }
     );
   } 

 signIn() {

final AuthCredential credential = PhoneAuthProvider.getCredential(
  verificationId: verificationId,
  smsCode: smsCode,
);

 FirebaseAuth.instance.signInWithCredential(credential).then((user){

                    WebServices(this.mApiListener).createAccount(this.phoneNo);
                    Navigator.of(context).pop();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
                   Home()
                   ));
                  
                  
      
}).catchError((e){
  print(e);
});

}
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Mobile verification",
              style:
              TextStyle(fontFamily: "Exo2", color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: Center(
             child: SingleChildScrollView(
            child: Column(
             
              children: <Widget>[
                  TextField(
           decoration: InputDecoration(hintText: 'Enter phone number'),
           onChanged: (value){
             this.phoneNo = value;
           },
           
         ),
         SizedBox(height: 10.0),
         RaisedButton(
           onPressed: verifyPhone,
           child: Text('verify'),
           textColor: Colors.white,
           elevation: 7.0,
           color: Colors.blue,
         )
        
                ],
            ),
          ),
                )
            
    );
  }


}


