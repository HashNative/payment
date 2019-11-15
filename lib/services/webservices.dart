import 'dart:convert';

import 'package:payment/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WebServices {
  ApiListener mApiListener;


  WebServices(this.mApiListener);

 Future<List<Data>> getData() async{
      var user = await http.get("https://www.hashnative.com/alloffers");
      var jsonData = json.decode(user.body);
      
      List<Data> datas = [];

      for (var d in jsonData){

      Data data = Data(d["id"],d["name"],d["location"],d["offer_item"],d["offer_price"],d["logo"],d["contact"],d["radius"]);
        datas.add(data);
      }
      return datas;
  }

 
  Future<String> updateAmount(String amount,String sender,String receiver) async{
    DateTime now = DateTime.now();
String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
   var url = 'https://www.hashnative.com/updateoffers';
   var response = await http.post(url, body: {'sender': '$sender','receiver': '$receiver',  'offer_price': '$amount',  'time': '$formattedDate',  'type': 'transfer'}); 
  
  print(response.statusCode);
     print(response.body);
     return response.body;
}

createAccount(String contact) async {
var url = 'https://www.hashnative.com/createaccount';
var response = await http.post(url, body: {'name': 'ilham', 'contact': '$contact',  'offer_price': '50'});
print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');
}

  
 Future<List<HistoryData>> getHistoryData() async{
     
      var user = await http.get('https://www.hashnative.com/gethistory');
      var jsonData = json.decode(user.body);
      print(user.body);
      List<HistoryData> datas = [];

      for (var d in jsonData){

      HistoryData data = HistoryData(d["id"],d["amount"],d["type"],d["sender"],d["receiver"],d["time"]);
        datas.add(data);
      }
      return datas;
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

class HistoryData {
   final String id;
  final String amount;
  final String type;
  final String sender;
  final String receiver;
  final String time;
  
 
  HistoryData(this.id, this.type, this.sender, this.receiver, this.time, this.amount);


}


