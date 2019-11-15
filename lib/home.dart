import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payment/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment/signin.dart';
import 'package:payment/history.dart';
import 'package:payment/widgets/update_amount.dart';


class Home extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
 final TextEditingController amountController = TextEditingController();
 ApiListener mApiListener;
 List<Data> offerResult;

 String userId;
int _user;


var users = <String>[
  'Bob',
  'Allie',
  'Jason',
];

   @override
  void initState() {

    currentUser().then((value){
       if (value!=null) {
       setState(() {
    this.userId=value.phoneNumber;
         });
       }
    });

    super.initState();
  


   WebServices(this.mApiListener).getData().then((result) {
       
        if (result!=null) {
          setState(() {
    offerResult = result.where((el)=>el.contact==this.userId).toList();
    
         });
         
        }
  
});
  
  
  }





  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("My Wallet",
              style:
              TextStyle(fontFamily: "Exo2", color: Colors.white)),
          backgroundColor: Colors.black,
        ),
              drawer: Drawer(
      
        child: ListView(
        
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Ilham Safeek'),
              accountEmail: Text('${this.userId}'),
                 currentAccountPicture: CircleAvatar(
                   child: Text("i"),              
                 ),
            ),
            ListTile(
              title: Text('Beneficiaries'),
            onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Transaction History'),
              onTap: () {
                
                Navigator.pop(context);
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => History()),
            );
              },
            ),
           Column(
             
              children: <Widget>[
                 RaisedButton(
           onPressed: () async{
            await FirebaseAuth.instance.signOut().then((action){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
          Signin()
        ));
            });
           },
           child: Text('Sign out'),
           textColor: Colors.white,
           elevation: 7.0,
           color: Colors.black,
         ) 
           
              ],
           )
           
          ],
        ),
      ),
        body: Center(
             child: SingleChildScrollView(
            child: Column(
             
              children: <Widget>[
               Text('${this.userId}'),
             
             offerResult!=null ? balaneCard(offerResult[0]) : Text('Fetching data..'),
                ],
            ),
          ),
                )
            
    );
  }


   Card balaneCard(Data data){
      FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
                      amount: double.parse('${data.offerPrice}')
                  );
     return  Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color.fromRGBO(255,128,0, 1.0),
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
         
         ListTile(
            leading: Icon(Icons.album, size: 70),
            title: Text('Balance', style: TextStyle(color: Colors.white)),
            subtitle: Text('LKR ${formattedAmount.output.nonSymbol}', style: TextStyle(fontFamily: "Exo2",color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
           
          ),
         ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Send', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    sendModalBottomSheet(context, data);
                  },
                ),
                FlatButton(
                  child: const Text('Recieve', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                   
                  },
                ),
              ],
            ),
          ),
        
             ],
      ),
    );
  
  }
  
   
  void sendModalBottomSheet(context,Data data){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
            children: <Widget>[
         ListTile(
            leading: new Icon(Icons.music_note),
            title: new Text('Send Money'),
            onTap: () => {}          
          ),
          ListTile(
            
            title:  new DropdownButton<String>(
  hint: new Text('Pickup on every'),
  value: _user == null ? null : users[_user],
  items: users.map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _user = users.indexOf(value);
    });
  },
),
           
            onTap: () => {}          
          ),
         
         
           ListTile(
            leading: Text(
                      '\LKR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
            title:  Padding(
                padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  children: <Widget>[
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                         
                          // inputFormatters: <TextInputFormatter>[
                          //   WhitelistingTextInputFormatter(RegExp("[abF!.]"))
                          //   ],
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                          decoration: InputDecoration(
                              hintText: 'Amount',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.0)),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            
            onTap: () => {}          
          ),
            
            ListTile(
          title: Row(
            children: <Widget>[
              Expanded(child: RaisedButton(
                onPressed: () {
                 
                 Navigator.pop(context);
//  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
//                    Home()
//                    ));

Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        UpdateAmount(amountController.text,this.userId, this.mApiListener)));



              },
              child: Text("Send"),color: Colors.orange,textColor: Colors.white,)),
              Expanded(child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  new Home();
                  },
              child: Text("Cancel"),color: Colors.black,textColor: Colors.white,)),
            ],
          ),
        )
            ],
          ),
          
          );
      }
    );
}

   Future<bool> smsCodeDialog(BuildContext context){
     return showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext contect){
       
       return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Mobile verification",
              style:
              TextStyle(fontFamily: "Exo2", color: Colors.white)),
          backgroundColor: Colors.black,
        ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          
          child: Column(
            children: <Widget>[
              
             Spacer(),
             Container(
               child: Ink(
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: CircleBorder(),
          
        ),
        child:  IconButton(
          icon: Icon(Icons.arrow_forward),
          color: Colors.white,
          onPressed: () {
           FirebaseAuth.instance.currentUser().then((user) {
                 if (user!=null) {
                   Navigator.of(context).pop();
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
                      Home()
                    ));
                 }else{
                   Navigator.of(context).pop();
                   
                 }
               });
          },
        ),
           ),
             ),
         
            ],
          ),
        ),
      ),
    );
       
       }
     );
   } 


   Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }


}

