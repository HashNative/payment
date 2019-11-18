import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payment/beneficiaries.dart';
import 'package:payment/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment/signin.dart';
import 'package:payment/history.dart';
import 'package:payment/widgets/update_amount.dart';
import 'package:payment/widgets/add_beneficiary.dart';


class Home extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
 final TextEditingController amountController = TextEditingController();
 
final TextEditingController beneficiaryController = TextEditingController();

 ApiListener mApiListener;
 List<Data> offerResult;

 String userId;
String _value;


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
      
        child: Column(
             mainAxisSize: MainAxisSize.min,
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
                Navigator.pop(context);
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Beneficiaries()),
            );
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
                 
                 new Expanded(
        child: new Align(
          alignment: Alignment.bottomCenter,
          child: Row(
              
              children: <Widget>[
                Expanded(
                  flex: 4,
                 child: FlatButton(
           onPressed: () async{
            await FirebaseAuth.instance.signOut().then((action){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
          Signin()
        ));
            });
           },
           child: Text('Sign out',style:
              TextStyle(fontFamily: "Exo2", color: Colors.blue, fontWeight: FontWeight.bold) ),
         ) ,
               
                ),
                Expanded(
                  flex: 1,
                  child: Text('v1.0'),
                )
                 
              ],

          )


         
        ),
      ), 


              ],
           )
         
      ),
        body: Center(
             child: SingleChildScrollView(
            child: Column(
             
              children: <Widget>[
              
             offerResult!=null ? balaneCard(offerResult[0]) : Text('Fetching data..'),
             _sendMoneySectionWidget()
                ],
            ),
          ),
                )
            
    );
  }

 Widget _sendMoneySectionWidget() {
    var smallItemPadding = EdgeInsets.only(
        left: 12.0, right: 12.0, top: 12.0);
    
    return Container(
//      color: Colors.yellow,
      margin: EdgeInsets.all(16.0),
//      height: 200.0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Send money to',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                 onTap: () {
                
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Beneficiaries()),
            );
                },
                child: Text('View all'),
              )
            ],
          ),
          Container(
            height: 100.0,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: smallItemPadding,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                onTap: () {
                 addBenificiaryModalBottomSheet();
                },
                child:  CircleAvatar(
                          child: Icon(Icons.add),
                        ),
           ),
                       
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Add new'),
                          
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: smallItemPadding,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          child: Text('T'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Salina'),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: smallItemPadding,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          child: Text('T'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Emily'),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: smallItemPadding,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          child: Text('T'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Nichole'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
            leading: new Icon(Icons.send),
            title: new Text('Send Money'),
            onTap: () => {}          
          ),
          ListTile(
            
            title: DropdownButton<String>(
          items: [
            DropdownMenuItem<String>(
              child: Text('Item 1'),
              value: 'one',
            ),
            DropdownMenuItem<String>(
              child: Text('Item 2'),
              value: 'two',
            ),
            DropdownMenuItem<String>(
              child: Text('Item 3'),
              value: 'three',
            ),
          ],
          onChanged: (String value) {
            setState(() {
              _value = value;
            });
          },
          hint: Text('Select Item'),
          value: _value,
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
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                                                  
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                          decoration: InputDecoration(
                              hintText: 'Amount',
                              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                              ),
                              
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
        UpdateAmount(amountController.text,this.userId, this.mApiListener,_value)));



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
  
   
  void addBenificiaryModalBottomSheet(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
            children: <Widget>[
         ListTile(
            leading: new Icon(Icons.person),
            title: new Text('Add new benificiary'),
            onTap: () => {}          
          ),
        
           ListTile(
            
            title:  Padding(
                padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  children: <Widget>[
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextFormField(
                          controller: beneficiaryController,
                          keyboardType: TextInputType.number,
                                                  
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                          decoration: InputDecoration(
                              hintText: 'Mobile Number',
                              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              
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

Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        AddBeneficiary(beneficiaryController.text,this.userId, this.mApiListener,_value)));



              },
              child: Text("Add"),color: Colors.blue,textColor: Colors.white,)),
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

