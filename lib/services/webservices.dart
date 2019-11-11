import 'dart:convert';

import 'package:payment/services/services.dart';
import 'package:http/http.dart' as http;

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

  updateAmount(String amount) async{
var user = await http.post("https://www.hashnative.com/updateoffers/16/$amount");
      json.decode(user.body);

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