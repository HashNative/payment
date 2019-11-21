import 'package:flutter/material.dart';
import 'package:payment/home.dart';
import 'package:payment/services/services.dart';
import 'package:payment/widgets/update_amount.dart';
import 'package:payment/widgets/add_beneficiary.dart';

class Dialogs {
  final TextEditingController amountController = TextEditingController();
    final TextEditingController beneficiaryController = TextEditingController();
  String _value;

  ApiListener mApiListener;

  Future<bool>  sendModalBottomSheet(context, String userId, List<String> data) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.send),
                    title: new Text('Send money'),
                    subtitle: TextFormField(
                                controller: beneficiaryController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Mobile Number',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ),
                    onTap: () => {}),
                ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child:  Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  UpdateAmount(amountController.text, userId,
                                      this.mApiListener, data[1])));
                        },
                        child: Text("Send"),
                        color: Colors.blue,
                        textColor: Colors.white,
                      )),
                      Expanded(
                          child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          new Home();
                        },
                        child: Text("Cancel"),
                        color: Colors.black,
                        textColor: Colors.white,
                      )),
                    ],
                  ),
                
                    ),
                    onTap: () => {}),              
              ],
            ),
          );
        });
  }

  Future<bool>  addBenificiaryModalBottomSheet(context, userId) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.person),
                    title: new Text('Add new benificiary'),
                    subtitle: TextFormField(
                                controller: beneficiaryController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Mobile Number',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ),
                    onTap: () => {}),
                ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child:  Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  AddBeneficiary(beneficiaryController.text,
                                      userId, this.mApiListener, _value)));
                        },
                        child: Text("Add"),
                        color: Colors.blue,
                        textColor: Colors.white,
                      )),
                      Expanded(
                          child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          new Home();
                        },
                        child: Text("Cancel"),
                        color: Colors.black,
                        textColor: Colors.white,
                      )),
                    ],
                  ),
                
                    ),
                    onTap: () => {}),              
              ],
            ),
          );
        });
  }



}
