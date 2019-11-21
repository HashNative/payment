import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment/services/services.dart';
import 'package:payment/widgets/dialogs.dart';

class Beneficiaries extends StatefulWidget {
  @override
  _BeneficiariesPageState createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<Beneficiaries> {
  ApiListener mApiListener;
  String userId;
  final globalKey = GlobalKey<ScaffoldState>();
  int _selectedIndex;
  String _selectedMobile;
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      if (value != null) {
        setState(() {
          this.userId = value.phoneNumber;
        });
      }
    });

    super.initState();
  }

  Future<bool> _onBackPressed() {
    _selectedIndex != null
        ? setState(() => _selectedIndex = null)
        : Navigator.of(context).pop(true);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: _selectedIndex == null
            ? Text("Beneficiaries",
                style: TextStyle(fontFamily: "Exo2", color: Colors.white))
            : FlatButton.icon(
                onPressed: () {
                  WebServices(this.mApiListener)
                      .deleteBeneficiary(_selectedMobile, this.userId)
                      .then((result) {
                    if (result != null) {
                      setState(() {
                        showSnackbar(context);
                        _selectedIndex=null;
                      });
                      
                    }
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                label: Text("data"),
              ),
        backgroundColor: Colors.black,
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
            child: FutureBuilder(
          future: WebServices(this.mApiListener).getBeneficiaries(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Fetching data..'),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: _selectedIndex != null && _selectedIndex == index
                        ? Colors.grey[300]
                        : Colors.white,
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                  '${snapshot.data[index].name[0].toUpperCase()}'),
                            ),
                            title: Text(snapshot.data[index].name),
                            trailing: Text(snapshot.data[index].mobile),
                            onTap: () {
                              List<String> account = List<String>();
                              account.add(snapshot.data[index].name);
                              account.add(snapshot.data[index].mobile);
                              Dialogs().sendModalBottomSheet(
                                  context, this.userId, account);
                            },
                            onLongPress: () {
                              setState(() {
                                _selectedIndex = index;
                                _selectedMobile = snapshot.data[index].mobile;
                              });
                            },
                          ),
                        ]),
                  );
                },
              );
            }
          },
        )),
      ),
    );
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Benficiary deleted'));
    globalKey.currentState.showSnackBar(snackBar);
  }
}
