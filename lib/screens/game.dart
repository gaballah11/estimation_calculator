import 'dart:math';

import 'package:estimation_calculator/modules/inGamePlayer.dart';
import 'package:estimation_calculator/modules/player.dart';
import 'package:estimation_calculator/screens/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:estimation_calculator/modules/scoring.dart';
import 'package:collection/collection.dart';

import '../widgets/button.dart';

final biddingProvider = StateProvider<bool>((ref) => false);

class gameSc extends ConsumerStatefulWidget {
  static const routename = '/game';

  const gameSc({Key? key}) : super(key: key);

  @override
  _gameScState createState() => _gameScState();
}

late var Gargs = null;
late List<inGamePlayer> players;

List<String> latestScore = [" ", " ", " ", " "];

class _gameScState extends ConsumerState<gameSc> {
  List<List<inGamePlayer>> rounds = [];
  int kingIndx = 0;
  int kuzIndx = 3;
  //bool _test = false;
  bool bidding = false;

  @override
  Widget build(BuildContext context) {
    print("building screen");
    final args = ModalRoute.of(context)!.settings.arguments as List<Player>;
    Gargs = args;
    players =
        args.map((e) => new inGamePlayer(e)).toList() as List<inGamePlayer>;

    final sz = MediaQuery.of(context).size;
    final biddingW = ref.watch(biddingProvider);

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
        Positioned(
            //alignment: Alignment.topRight,
            right: 0,
            top: sz.height * 0.13,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                  children: args.map((e) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: sz.width * 0.15,
                        child: Image.asset(e.imgAsset),
                      ),
                      SizedBox(
                        height: 5,
                      ),
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
              }).toList()),
            )),
        Container(
          margin:
              const EdgeInsets.only(top: 210, left: 25, right: 25, bottom: 20),
          height: sz.height * 0.7,
          child: ListView.builder(
            itemCount: rounds.length,
            itemBuilder: (_, indx) {
              return Container(
                width: sz.width / 1.2,
                height: 80,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: indx == rounds.length - 1
                          ? () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      contentPadding: EdgeInsets.all(20.0),
                                      content: Text(
                                        "Are you sure you want to remove round #${indx + 1} ?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Lucida",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text("NO",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ))),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              rounds.removeAt(indx);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text("YES",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ))),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          : () {},
                      style: ButtonStyle(
                        backgroundColor: indx == rounds.length - 1
                            ? MaterialStateProperty.all(
                                Colors.redAccent.withOpacity(0.5))
                            : MaterialStateProperty.all(
                                Colors.black87.withOpacity(0.5)),
                        minimumSize: MaterialStateProperty.all(Size.zero),
                        shape: MaterialStateProperty.all(CircleBorder()),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (indx + 1).toString(),
                          style: TextStyle(
                            fontFamily: "Lucida",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: rounds[indx].map((e) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      e.bid.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Lucida",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    e.isCall
                                        ? Image.asset(
                                            "assets/${e.orderedColor}.png",
                                            height: 20,
                                          )
                                        : Container(),
                                    e.isWith
                                        ? Text(
                                            "W",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontFamily: "Lucida",
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : Container(),
                                    e.risk != "No Risk"
                                        ? Text(
                                            "R",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontFamily: "Lucida",
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  e.score.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Lucida",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Align(
          alignment: const Alignment(0.85, 0.95),
          child: Container(
              width: 80,
              height: 80,
              child: Consumer(builder: (context, ref, _) {
                return FloatingActionButton(
                  backgroundColor: Color.fromRGBO(200, 0, 3, 1.0),
                  mini: true,
                  onPressed: () {
                    if (!biddingW) {
                      ref.read(playersProvider.notifier).state = [];
                      for (Player p in args) {
                        ref.read(playersProvider.notifier).add(p);
                      }
                    } else {
                      ref.read(playersProvider.notifier).state = [];
                    }
                    biddingW ? endround(rounds.last) : addNewRound(Gargs);
                    ref.read(biddingProvider.notifier).state = !biddingW;
                  },
                  tooltip: 'Bids',
                  child: biddingW
                      ? Icon(Icons.done_rounded, size: 40.0)
                      : Icon(Icons.add_rounded, size: 40.0),
                );
              })),
        ),
      ],
    ));
  }

  Future<void> addNewRound(List<Player> args) async {
    try {
      List<inGamePlayer> newRound = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return alert(args);
        },
      );
      if (newRound != null) {
        setState(() {
          print("adding round...........");
          rounds.add(newRound);
        });
        print(rounds.length);
      }
    } catch (e) {
      print(e);
      ref.read(biddingProvider.notifier).state =
          !ref.read(biddingProvider.notifier).state;
      setState(() {
        bidding = !bidding;
      });
    }
  }

  Future<void> endround(List<inGamePlayer> round) async {
    try {
      List<inGamePlayer> alerty = await showDialog(
          context: context,
          builder: (_) {
            return alert2(round);
          });
      if (alerty != null) {
        //ref.read(biddingProvider.notifier).state=!ref.read(biddingProvider.notifier).state;
      }
    } catch (e) {
      print("nothing");
      ref.read(biddingProvider.notifier).state =
          !ref.read(biddingProvider.notifier).state;
    }
  }
}

class alert2 extends ConsumerStatefulWidget {
  List<inGamePlayer> rnd;

  alert2(this.rnd);

  @override
  ConsumerState<alert2> createState() => _alert2State();
}

class _alert2State extends ConsumerState<alert2> {
  late List<TextEditingController> calls;

  @override
  void initState() {
    // TODO: implement initState
    calls = [
      new TextEditingController(text: '0'),
      new TextEditingController(text: '0'),
      new TextEditingController(text: '0'),
      new TextEditingController(text: '0')
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var rnd = widget.rnd;
    final sz = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
        title: const Text(
          "End Round",
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
        content: Consumer(
          builder: (ctx, ref, ch) {
            final players = ref.watch(playersProvider.notifier);
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return GestureDetector(
                  onTap: () {
                    print("taaaaaaaap");
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: sz.height * 0.4,
                        width: sz.width / 1.5,
                        child: Form(
                          key: formKey,
                          child: PageView.builder(
                              controller:
                                  PageController(viewportFraction: 0.88),
                              itemCount: 4,
                              itemBuilder: (_, indx) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  //width: sz.width * 0.8,
                                  //height: sz.width * 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  200, 0, 3, 1.0),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              Gargs[indx].imgAsset,
                                              scale: 6,
                                            ),
                                            Text(
                                              Gargs[indx].name +
                                                  "'s Bid" +
                                                  "\n" +
                                                  rnd[indx].bid.toString(),
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    200, 0, 3, 1.0),
                                                fontFamily: "Lucida",
                                                fontStyle: FontStyle.italic,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: TextFormField(
                                          onChanged: (res) {},
                                          style: TextStyle(
                                            fontFamily: "Lucida",
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                          controller: calls[indx],
                                          validator: (s) {
                                            if (int.parse(s!) > 13)
                                              return "Can't be more than 13";
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            labelText:
                                                "Number of tricks Collected",
                                            labelStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  200, 0, 3, 1.0),
                                              fontFamily: "Lucida",
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (players.getSumBids() == 13) {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(
                                msg: "sum of all bids can't be 13",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            } else {
                              //ref.read(playersProvider.notifier).state=[];
                              print("round ended");
                              for (TextEditingController call in calls) {
                                print(call.text);
                              }

                              rnd = await updateScores(calls, rnd);
                              Navigator.pop(context, rnd);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Done",
                            style: TextStyle(
                              fontFamily: "Lucida",
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(200, 0, 3, 1.0)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ))),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
    return alert;
  }

  Future<List<inGamePlayer>> updateScores(
      List<TextEditingController> calls, List<inGamePlayer> rnd) async {
    late scoring score;
    Future<void> waitForScore() async {
      score = scoring();
    }

    waitForScore().then((value) {
      print("dashloseover ${score.dashLoseOver}");
      score.printing();
      List<int> winStatus = [0, 0, 0, 0];
      int roundSum = 0;

      for (int i = 0; i < rnd.length; ++i) {
        print('${rnd[i].bid} == ${int.parse(calls[i].text)}');
        if (rnd[i].bid == int.parse(calls[i].text)) {
          print('win');
          //win
          winStatus[i] = 1;
        }
      }

      int bidstotal = 0;
      for (int i = 0; i < rnd.length; ++i) {
        bidstotal += rnd[i].bid;
      }

      for (int i = 0; i < winStatus.length; ++i) {
        roundSum += winStatus[i];
      }
      print('roun sum $roundSum');
      print('bidsTotal $bidstotal');

      for (int i = 0; i < winStatus.length; ++i) {
        if (winStatus[i] == 1) {
          //winnnnnnnnnnn

          if (rnd[i].bid == 0 && rnd[i].isCall) {
            //DashCall
            if (bidstotal < 13) {
              rnd[i].score += score.dashWinUnder;
            } else {
              rnd[i].score += score.dashWinOver;
            }
            //continue;
          } else if (rnd[i].bid >= 8) {
            //Big Calls
            rnd[i].score += pow(rnd[i].bid, 2).round();
            //continue;
          } else {
            //basic
            rnd[i].score += score.win + rnd[i].bid; // regular
          }
          if (rnd[i].isCall && rnd[i].bid != 0 && rnd[i].bid < 8)
            rnd[i].score += 10; //call
          if (rnd[i].isWith) rnd[i].score += 10; // with
          if (winStatus[i] == 1 && roundSum == 1) {
            rnd[i].score += score.onlyWin;
          } //only win
          if (rnd[i].risk != "No Risk") {
            //risk
            if (rnd[i].risk == "Risk") rnd[i].score += 10;
            if (rnd[i].risk == "2x Risk") rnd[i].score += 20;
            if (rnd[i].risk == "3x Risk") rnd[i].score += 30;
          }
        } else {
          //loseeeeeeeeeeeeeee

          if (rnd[i].bid == 0 && rnd[i].isCall) {
            //DashCall
            if (bidstotal < 13) {
              rnd[i].score -= score.dashLoseUnder;
            } else {
              rnd[i].score -= score.dashLoseOver;
            }
            continue;
          } else if (rnd[i].bid >= 8) {
            //Big Calls
            rnd[i].score -= (pow(rnd[i].bid, 2) / 2).round();
            continue;
          } else {
            //basic
            rnd[i].score -= score.lose +
                (rnd[i].bid - int.parse(calls[i].text)).abs(); // regular
          }
          if (rnd[i].isCall && rnd[i].bid != 0 && rnd[i].bid < 8)
            rnd[i].score -= 10; //call
          if (rnd[i].isWith) rnd[i].score -= 10; // with
          if (winStatus[i] == 0 && roundSum == 3)
            rnd[i].score -= score.onlyLose; //only lose
          if (rnd[i].risk != "No Risk") {
            //risk
            if (rnd[i].risk == "Risk") rnd[i].score -= 10;
            if (rnd[i].risk == "2x Risk") rnd[i].score -= 20;
            if (rnd[i].risk == "3x Risk") rnd[i].score -= 30;
          }
        }
        print('${i + 1} score : ${rnd[i].score}');
      }
    });
    return rnd;
  }
}

class alert extends ConsumerStatefulWidget {
  List<Player> args;
  alert(this.args);

  @override
  alertState createState() {
    return new alertState(args);
  }
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class alertState extends ConsumerState<alert>
    with AutomaticKeepAliveClientMixin {
  late List<TextEditingController> calls;
  List<Player> args;
  alertState(this.args);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    calls = [
      new TextEditingController(text: '0'),
      new TextEditingController(text: '0'),
      new TextEditingController(text: '0'),
      new TextEditingController(text: '0')
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("building alert");
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
        content: Consumer(
          builder: (ctx, ref, ch) {
            final players = ref.watch(playersProvider.notifier);
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                var colors = [
                  'No Trump',
                  'spades',
                  'hearts',
                  'diamonds',
                  'clubs'
                ];
                var riskStatus = ['No Risk', 'Risk', '2x Risk', '3x Risk'];

                return GestureDetector(
                  onTap: () {
                    print("taaaaaaaap");
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: sz.height * 0.4,
                        width: sz.width / 1.5,
                        child: Form(
                          key: formKey,
                          child: PageView.builder(
                              controller:
                                  PageController(viewportFraction: 0.88),
                              itemCount: 4,
                              itemBuilder: (_, indx) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  //width: sz.width * 0.8,
                                  //height: sz.width * 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  200, 0, 3, 1.0),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              Gargs[indx].imgAsset,
                                              scale: 6,
                                            ),
                                            Text(
                                              Gargs[indx].name + "'s Bid",
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    200, 0, 3, 1.0),
                                                fontFamily: "Lucida",
                                                fontStyle: FontStyle.italic,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: TextFormField(
                                          onChanged: (res) {
                                            ref
                                                .read(playersProvider.notifier)
                                                .setBid(indx, int.parse(res));
                                          },
                                          style: TextStyle(
                                            fontFamily: "Lucida",
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                          controller: calls[indx],
                                          validator: (s) {
                                            if (int.parse(s!) > 13)
                                              return "Can't be more than 13";
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            labelText:
                                                "Number of tricks ordered",
                                            labelStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  200, 0, 3, 1.0),
                                              fontFamily: "Lucida",
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: sz.width * 0.6,
                                        child: SwitchListTile.adaptive(
                                            title: const Text(
                                              "Is Call",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    200, 0, 3, 1.0),
                                                fontFamily: "Lucida",
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                            value: ref
                                                .watch(playersProvider.notifier)
                                                .state[indx]
                                                .isCall,
                                            //autofocus: true ,
                                            onChanged: (val) {
                                              FocusScope.of(context).unfocus();
                                              ref
                                                  .read(
                                                      playersProvider.notifier)
                                                  .toggleIsCall(indx);
                                            }),
                                      ),
                                      players.state[indx].isCall
                                          ? DropdownButton(
                                              underline: Container(),
                                              isDense: true,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              hint: Opacity(
                                                opacity: 0.5,
                                                child: Image.asset(
                                                  "assets/spades.png",
                                                  width: sz.width * 0.08,
                                                ),
                                              ),
                                              value: players
                                                  .state[indx].orderedColor,
                                              items: colors.map((e) {
                                                return DropdownMenuItem(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        "assets/$e.png",
                                                        width: sz.width * 0.08,
                                                      ),
                                                      Text(e),
                                                    ],
                                                  ),
                                                  value: e,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                ref
                                                    .read(playersProvider
                                                        .notifier)
                                                    .setOColor(indx,
                                                        newVal.toString());
                                              })
                                          : Divider(),
                                      Container(
                                        width: sz.width * 0.6,
                                        child: SwitchListTile.adaptive(
                                            title: const Text(
                                              "Is With",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    200, 0, 3, 1.0),
                                                fontFamily: "Lucida",
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                            value: players.state[indx].isWith,
                                            onChanged: (val) {
                                              FocusScope.of(context).unfocus();
                                              ref
                                                  .read(
                                                      playersProvider.notifier)
                                                  .toggleIsWith(indx);
                                            }),
                                      ),
                                      DropdownButton(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        value: players.state[indx].risk,
                                        items: riskStatus.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          ref
                                              .read(playersProvider.notifier)
                                              .setRisk(indx, newVal.toString());
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (players.getSumBids() == 13) {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(
                                msg: "sum of all bids can't be 13",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            } else {
                              List<inGamePlayer> round = players.state;
                              Navigator.pop(context, round);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Done",
                            style: TextStyle(
                              fontFamily: "Lucida",
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(200, 0, 3, 1.0)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ))),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
    return alert;
  }

  @override
  bool get wantKeepAlive => true;
}
