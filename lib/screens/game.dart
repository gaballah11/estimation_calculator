import 'package:estimation_calculator/modules/player.dart';
import 'package:estimation_calculator/screens/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';

class gameSc extends StatefulWidget {
  static const routename = '/game';

  const gameSc({Key? key}) : super(key: key);

  @override
  _gameScState createState() => _gameScState();
}

class _gameScState extends State<gameSc> {
  TextEditingController zeroCont = new TextEditingController();
  TextEditingController oneCont = new TextEditingController();
  TextEditingController twoCont = new TextEditingController();
  TextEditingController threeCont = new TextEditingController();
  List<bool> isCall = [false, false, false, false];
  List<bool> isWith = [false, false, false, false];
  var orderedColor;
  bool _test = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<Player>;
    final sz = MediaQuery.of(context).size;
    int roundNo = 0;
    Key roundsNoKey = new Key("roundsNoKey");
    return Scaffold(
        body: Stack(
      children: [
        Opacity(
          opacity: 0.02,
          child: Image.asset(
            "assets/back.png",
            height: sz.height,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset("assets/bottom.png"),
        ),
        Align(
            alignment: const Alignment(0, -0.9),
            child: Image.asset(
              "assets/logo-01.png",
              width: sz.width / 2.1,
            )),
        Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: sz.height * 0.13),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Table(
                  
                  columnWidths: const {
                    0: FractionColumnWidth(.22),
                    1: FractionColumnWidth(.22),
                    2: FractionColumnWidth(.22),
                    3: FractionColumnWidth(.22),
                  },
                  children: [
                    TableRow(
                        children: args.map((e) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: sz.width*0.15,
                              child: Image.asset(e.imgAsset),
                            ),
                            SizedBox(height: 5,),
                            Container(

                              child: Text(
                                e.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Lucida",
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList())
                  ],
                ),
              ),
            )),
        Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: sz.height * 0.24 + 40),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  key: roundsNoKey,
                  children: [Text(roundNo.toString())],
                ),
              ),
            )),
        Align(
          alignment: const Alignment(0.92, 0.95),
          child: Container(
            width: 80,
            height: 80,
            child: button(
              Container(
                margin: EdgeInsets.only(top: 4, left: 4),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: sz.width / 10,
                ),
              ),
              () {
                addNewRound(args);
              },
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> addNewRound(List<Player> args) async {
    final sz = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
      title: const Text(
        "New Round",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromRGBO(200, 0, 3, 1.0),
          fontFamily: "Lucida",
          fontStyle: FontStyle.italic,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      content: SizedBox(
        width: sz.width * 0.8,
        height: sz.width * 0.8,
        child: PageView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(200, 0, 3, 1.0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        args[0].imgAsset,
                        scale: 5,
                      ),
                      Text(
                        args[0].name + "'s Bid",
                        style: TextStyle(
                          color: Color.fromRGBO(200, 0, 3, 1.0),
                          fontFamily: "Lucida",
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                buildInputLabel("Number of tricks ordered", zeroCont),
                Row(
                  children: [
                    Container(
                      width: sz.width*0.6,
                      child: SwitchListTile(
                          title: const Text(
                            "Is Call",
                            style: TextStyle(
                              color: Color.fromRGBO(200, 0, 3, 1.0),
                              fontFamily: "Lucida",
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          value: _test,
                          onChanged: (val) {
                            setState(() {
                              _test = val;
                              print(_test);
                            });
                          }),
                    ),

                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
