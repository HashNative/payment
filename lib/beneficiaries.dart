import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment/services/services.dart';
import 'package:payment/home.dart';
import 'package:payment/widgets/update_amount.dart';


class Beneficiaries extends StatefulWidget {
  
  @override
  _BeneficiariesPageState createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<Beneficiaries> {
 final TextEditingController amountController = TextEditingController();

ApiListener mApiListener;
 String userId;

  int _selectedIndex;

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

 Future<bool> _onBackPressed() {
    
_selectedIndex != null
                  ?  setState(() => _selectedIndex = null)
                  : Navigator.of(context).pop(true);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    
    
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _selectedIndex == null
          ?Text("Beneficiaries",
              style:
              TextStyle(fontFamily: "Exo2", color: Colors.white))
          :FlatButton.icon(
                          onPressed: 
                          () {
                             
                              }
                          , 
                          icon: Icon(Icons.delete,color: Colors.white,),
                          label: Text(""),
                          
                          ),    
          backgroundColor: Colors.black,
        ),
        body: 
        WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
             child: FutureBuilder(
                 future: WebServices(this.mApiListener).getBeneficiaries(),
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
                        
                        return Card(
                            color: _selectedIndex != null && _selectedIndex == index
                  ? Colors.grey[300]
                  : Colors.white,
                            child: 
                            new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      new ListTile(  
                                          
                          leading: CircleAvatar(child: Text('${snapshot.data[index].name[0].toUpperCase()}'),),
                          title: Text(snapshot.data[index].name),
                          trailing: Text(snapshot.data[index].mobile),
                          onTap:() {
                            List<String> account=List<String>();
                            account.add(snapshot.data[index].name);
                            account.add(snapshot.data[index].mobile);
                            sendModalBottomSheet(context,account);   
                              },
                              onLongPress: () {
                          setState(() => _selectedIndex = index);
                              },
                        ),
                       
                           ]),
                            
                           
                        );
                        
                        
                        
                       
                      },
                   );
                   }
                   
                   
                 },
               )
               
                ),
      ),
        
        
           
    );
  
    
    
  }

 

 void sendModalBottomSheet(context,List<String> data){
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
           leading: Text(data[0]),
           title: Text(data[1]),
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
        UpdateAmount(amountController.text,this.userId, this.mApiListener,data[1])));



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



}

