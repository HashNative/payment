import 'dart:convert';

import 'package:payment/services/services.dart';
import 'package:http/http.dart' as http;

class WebServices {
  ApiListener mApiListener;


  WebServices(this.mApiListener);

 Future<List<Data>> getData(String mobile) async{
     
      var user = await http.get("https://www.hashnative.com/alloffers/$mobile");
      var jsonData = json.decode(user.body);

      List<Data> datas = [];

      for (var d in jsonData){

      Data data = Data(d["id"],d["name"],d["location"],d["offer_item"],d["offer_price"],d["logo"],d["contact"],d["radius"]);
        datas.add(data);
      }
      return datas;
  }

 
  Future<int> updateAmount(String amount,String sender,String receiver) async{
   var url = 'https://www.hashnative.com/updateoffers';
   var response = await http.post(url, body: {'sender': '$sender','receiver': '$receiver',  'offer_price': '$amount'}); 
  
    // print(response.body);
     return response.statusCode;
}

createAccount(String contact) async {
var url = 'https://www.hashnative.com/createaccount';
var response = await http.post(url, body: {'name': 'ilham', 'contact': '$contact',  'offer_price': '50'});
print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');
}


}


class Data {
   final String id;
  final String name;
  final String location;
  final String offerItem;
  final String offerPrice;
  final String logo;
  final String contact;
  final String radius;
 

  Data(this.id, this.name, this.location, this.offerItem, this.offerPrice, this.logo, this.contact, this.radius);




}