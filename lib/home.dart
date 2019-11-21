import 'package:flutter/material.dart';
import 'package:payment/beneficiaries.dart';
import 'package:payment/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment/signin.dart';
import 'package:payment/history.dart';
import 'package:payment/widgets/dialogs.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  ApiListener mApiListener;
  List<Data> offerResult;

  String userId;

  @override
  void initState() {
    currentUser().then((value) {
      if (value != null) {
        setState(() {
          this.userId = value.phoneNumber;
        });
      }
    });

    super.initState();

    WebServices(this.mApiListener).getData().then((result) {
      if (result != null) {
        setState(() {
          offerResult =
              result.where((el) => el.contact == this.userId).toList();
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
              style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
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
                          onPressed: () async {
                            await FirebaseAuth.instance
                                .signOut()
                                .then((action) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Signin()));
                            });
                          },
                          child: Text('Sign out',
                              style: TextStyle(
                                  fontFamily: "Exo2",
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('v1.0'),
                      )
                    ],
                  )),
            ),
          ],
        )),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                offerResult != null
                    ? balaneCard(offerResult[0])
                    : Text('Fetching data..'),
                _sendMoneySectionWidget()
              ],
            ),
          ),
        ));
  }

  Widget _sendMoneySectionWidget() {
    var smallItemPadding = EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0);

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
                            Dialogs().addBenificiaryModalBottomSheet(
                                context, this.userId);
                          },
                          child: CircleAvatar(
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
                  FutureBuilder(
                    future: WebServices(this.mApiListener).getBeneficiaries(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: smallItemPadding,
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      List<String> account = List<String>();
                                      account.add(snapshot.data[index].name);
                                      account.add(snapshot.data[index].mobile);
                                      Dialogs().sendModalBottomSheet(
                                          context, userId, account);
                                    },
                                    child: CircleAvatar(
                                      child: Text(
                                          '${snapshot.data[index].name[0].toUpperCase()}'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(snapshot.data[index].name),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card balaneCard(Data data) {
    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('${data.offerPrice}'));
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color.fromRGBO(255, 128, 0, 1.0),
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album, size: 70),
            title: Text('Balance', style: TextStyle(color: Colors.white)),
            subtitle: Text('LKR ${formattedAmount.output.nonSymbol}',
                style: TextStyle(
                    fontFamily: "Exo2",
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child:
                      const Text('Send', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    //sendModalBottomSheet(context);
                  },
                ),
                FlatButton(
                  child: const Text('Recieve',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _showDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contect) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Mobile verification",
                  style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
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
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          onPressed: () {
                            FirebaseAuth.instance.currentUser().then((user) {
                              if (user != null) {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Home()));
                              } else {
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
        });
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
