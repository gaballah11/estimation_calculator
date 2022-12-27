import 'dart:convert';

import 'package:estimation_calculator/modules/player.dart';
import 'package:estimation_calculator/screens/setting.dart';
import 'package:estimation_calculator/widgets/button.dart';
import 'package:estimation_calculator/widgets/swiper.dart';
import 'package:estimation_calculator/screens/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class playersSc extends StatefulWidget {
  static const routename = '/players';

  const playersSc({Key? key}) : super(key: key);

  @override
  _playersScState createState() => _playersScState();
}

class _playersScState extends State<playersSc> {
  TextEditingController playername = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _swiperkey = GlobalKey<charachterSwiperState>();
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _stackKey = GlobalKey();
  List<String> characters = [];
  List<Player> players = [];
  List<Player> selected = [];

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 1; i <= 19; ++i) {
      characters.add("assets/charachters/$i.png");
    }

    getPlayersFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: Stack(
        key: _stackKey,
        alignment: Alignment.center,
        children: [
          Container(
            width: sz.width,
            height: sz.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 1.0),
                Color.fromRGBO(255, 255, 255, 0.5),
                Color.fromRGBO(127, 0, 3, 0.5)
              ],
              begin: Alignment(0.0, 0.0),
              end: Alignment.bottomCenter,
            )),
          ),
          Opacity(
            opacity: 0.02,
            child: Image.asset(
              "assets/back.png",
              height: sz.height,
              fit: BoxFit.cover,
            ),
          ),
          Align(
              alignment: const Alignment(0, -0.9),
              child: Image.asset(
                "assets/logo-01.png",
                width: sz.width / 1.7,
              )),
          Align(
              alignment: const Alignment(-0.9, -0.65),
              child: Container(
                margin: EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: button(
                        Container(
                          margin: EdgeInsets.only(top: 8, left: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.short_text_rounded,
                            color: Colors.white,
                            size: sz.width / 10,
                          ),
                        ),
                        () {
                          print(sz);
                          print(sz.aspectRatio);
                          showDropDownMenuAlert(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "SELECT PLAYERS",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Lucida",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              )),
          FutureBuilder(
              future: getPlayersFromDatabase(),
              builder: (ctx, snapshot) {
                return Container(
                  margin: EdgeInsets.only(top: sz.height * 0.24),
                  child: GridView.count(
                    padding: EdgeInsets.all(20),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 15,
                    crossAxisCount: 2,
                    children: players.map((e) {
                      return GestureDetector(
                        onTap: () {
                          print(selected.length);
                          if (selected.contains(e)) {
                            setState(() {
                              selected.remove(e);
                            });
                          } else {
                            if (selected.length < 4) {
                              setState(() {
                                selected.add(e);
                              });
                            } else {
                              print("more than 4");
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(
                                msg: "You can't add more than 4 players",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                              print(selected);
                            }
                          }
                        },
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: selected.contains(e)
                                ? const BorderSide(
                                    color: Color.fromRGBO(200, 0, 3, 1.0),
                                    width: 3)
                                : BorderSide.none,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    e.imgAsset,
                                    height: sz.height * 0.15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: selected.contains(e)
                                            ? Color.fromRGBO(200, 0, 3, 1.0)
                                            : Colors.black54,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(40.0))),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(7),
                                    width: double.infinity,
                                    child: Text(
                                      e.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Lucida",
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Align(
                                  alignment: Alignment(-0.8, -0.8),
                                  child: selected.contains(e)
                                      ? Icon(
                                          Icons.check_circle_rounded,
                                          size: sz.width * 0.06,
                                          color: Color.fromRGBO(200, 0, 3, 1.0),
                                        )
                                      : Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: sz.width * 0.06,
                                        ))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
          Align(
            alignment: const Alignment(0.9, 0.7),
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
                  showPlayerSelection(context);
                },
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, 0.9),
            child: Container(
              width: 80,
              height: 80,
              child: selected.length < 4
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        foregroundDecoration: const BoxDecoration(
                          color: Colors.grey,
                          backgroundBlendMode: BlendMode.saturation,
                        ),
                        child: button(
                          Container(
                            margin: EdgeInsets.only(top: 4, left: 4),
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: sz.width / 10,
                            ),
                          ),
                          () {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(
                              msg: "Select 4 players to start",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          },
                        ),
                      ),
                    )
                  : button(
                      Container(
                        margin: EdgeInsets.only(top: 4, left: 4),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: sz.width / 10,
                        ),
                      ),
                      () {
                        Navigator.of(context)
                            .pushNamed(gameSc.routename, arguments: selected);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showPlayerSelection(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Choose your character",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromRGBO(200, 0, 3, 1.0),
          fontFamily: "Lucida",
          fontStyle: FontStyle.italic,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(width: 800),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  charachterSwiper(
                    MediaQuery.of(context).size,
                    key: _swiperkey,
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontFamily: "Lucida",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    autofocus: true,
                    controller: playername,
                    validator: (val) {
                      final photoIndx = _swiperkey.currentState!.currentIndex;
                      Player p =
                          Player(name: val!, imgAsset: characters[photoIndx]);
                      if (val.length < 3) {
                        return "name should be more than 3 characters";
                      } else if (players.contains(p)) {
                        return "the same player exist";
                      }
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      labelText: "Player name",
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(200, 0, 3, 1.0),
                        fontFamily: "Lucida",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      hintText: "type the player's name ...",
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final photoIndx = _swiperkey.currentState!.currentIndex;
                    Player p = Player(
                        name: playername.text, imgAsset: characters[photoIndx]);
                    //print("Player : ${p.name} , ${p.imgAsset}");
                    Navigator.pop(context, p);
                  }
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Lucida",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "Lucida",
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
    final Player newPlayer = await showDialog(
      context: context,
      builder: (BuildContext context) {
        playername.clear();
        return alert;
      },
    );
    if (newPlayer != null) {
      print(newPlayer.name + " " + newPlayer.imgAsset);
      players.add(newPlayer);

      addPlayersToDatabase();
    }
  }

  addPlayersToDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final playersJson =
        jsonEncode(players.map((e) => e.toJsonPlayer()).toList());
    print(playersJson);
    prefs.setString('players', playersJson);
  }

  getPlayersFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('players')) {
      final playersString = prefs.getString("players");
      final temp = json.decode(playersString!);
      //print(temp);
      List<Player> temp2 =
          List<Player>.from(temp.map((e) => Player.fromJson(e)));
      players = temp2;
    } else {
      players = [];
    }
    print(players);
  }

  ListTile buildlistTile(String title, Widget icon, Function funct) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Lucida',
          fontSize: 18,
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => funct(),
    );
  }

  Future<void> showDropDownMenuAlert(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(
          color: Colors.white,
          width: 3,
        ),
      ),
      backgroundColor: const Color.fromRGBO(200, 0, 3, 1.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildlistTile(
              "Settings",
              Icon(
                Icons.settings,
                color: Colors.white,
              ), () {
            Navigator.of(context).pushNamed(settingSc.routename);
          }),
          Divider(),
          buildlistTile(
              "Statistics",
              Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
              ),
              () {}),
          Divider(),
          buildlistTile(
            "Rules",
            Icon(
              Icons.paste,
              color: Colors.white,
            ),
            () {},
          )
        ],
      ),
    );

    await showDialog(
      barrierColor: Colors.black.withOpacity(0),
      context: context,
      builder: (BuildContext ctx) {
        final sz = MediaQuery.of(context).size;
        return Container(
          margin:
              EdgeInsets.only(bottom: sz.height * 0.4, right: sz.width * 0.15),
          child: alert,
        );
      },
    );
  }
}
