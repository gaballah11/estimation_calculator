import 'dart:math';

import 'package:estimation_calculator/modules/inGamePlayer.dart';
import 'package:estimation_calculator/modules/player.dart';
import 'package:estimation_calculator/modules/theme.dart';
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
int kingIndx = 0;
int kuuzIndx = 3;
int Factor = 1;

List<List<int>> roundsScores = [
  [0, 0, 0, 0]
];

class _gameScState extends ConsumerState<gameSc> {
  List<List<inGamePlayer>> rounds = [];
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
              padding: const EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: args.asMap().entries.map((entry) {
                    int idx = entry.key;
                    Player e = entry.value;
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      ref.watch(themeProvider) != ThemeMode.dark
                                          ? Colors.black.withOpacity(0.1)
                                          : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 50,
                                child: Image.asset(e.imgAsset),
                              ),
                              roundsScores.length > 1 && idx == kingIndx
                                  ? Image.asset(
                                      "assets/king.png",
                                      width: 50,
                                      //height: 50,
                                    )
                                  : Container(),
                              roundsScores.length > 1 && idx == kuuzIndx
                                  ? Image.asset(
                                      "assets/kuz.png",
                                      width: 50,
                                      //height: 50,
                                    )
                                  : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              e.name,
                              style: const TextStyle(
                                //color: Colors.black,
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
              const EdgeInsets.only(top: 230, left: 25, right: 25, bottom: 20),
          height: sz.height * 0.7,
          child: ListView.builder(
            itemCount: rounds.length,
            itemBuilder: (_, indx) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
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
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40.0)),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          contentPadding:
                                              const EdgeInsets.all(20.0),
                                          content: Text(
                                            "Are you sure you want to remove round #${indx + 1} ?",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: "Lucida",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all(RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0)))),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: const Text("NO",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ))),
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all(RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0)))),
                                              onPressed: () {
                                                setState(() {
                                                  rounds.removeAt(indx);
                                                  ref
                                                              .read(
                                                                  biddingProvider
                                                                      .notifier)
                                                              .state ==
                                                          true
                                                      ? () {}
                                                      : roundsScores
                                                          .removeAt(indx + 1);
                                                });
                                                ref
                                                    .read(biddingProvider
                                                        .notifier)
                                                    .state = false;

                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: const Text("YES",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    Colors.redAccent.withOpacity(0.4))
                                : MaterialStateProperty.all(
                                    Colors.black87.withOpacity(0.4)),
                            minimumSize: MaterialStateProperty.all(Size.zero),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (indx + 1).toString(),
                              style: const TextStyle(
                                  fontFamily: "Lucida",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70),
                              softWrap: false,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: rounds[indx].map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        e.bid.toString(),
                                        style: const TextStyle(
                                          //color: Colors.black,
                                          fontFamily: "Lucida",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      e.isCall && e.bid == 0
                                          ? const Text(
                                              " DC",
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontFamily: "Lucida",
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : e.isCall
                                              ? Image.asset(
                                                  "assets/${e.orderedColor}.png",
                                                  height: 20,
                                                )
                                              : Container(),
                                      e.isWith
                                          ? const Text(
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
                                              returnRiskSymbol(e.risk),
                                              style: const TextStyle(
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
                                );
                              }).toList(),
                            ),
                            roundsScores.length > rounds.length
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: roundsScores[indx + 1].map((e) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          e.toString(),
                                          style: const TextStyle(
                                            //color: Colors.black,
                                            fontFamily: "Lucida",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : indx < roundsScores.length - 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children:
                                            roundsScores[indx + 1].map((e) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              e.toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Lucida",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : Container(),
                          ],
                        )
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    int sum = 0;
                    rounds[indx].forEach(
                      (e) {
                        sum += e.bid;
                      },
                    );
                    int game = sum - 13;
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: game.isNegative
                              ? const Color.fromRGBO(224, 40, 74, 1.0)
                              : const Color.fromRGBO(0, 200, 3, 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          game.isNegative ? "-${game.abs()}" : "+${game.abs()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Lucida",
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    );
                  })
                ],
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
                return biddingW
                    ? GestureDetector(
                        onTap: () {
                          ref.read(playersProvider.notifier).state = [];
                          endround(rounds.last);
                          ref.read(biddingProvider.notifier).state = !biddingW;
                        },
                        child: Image.asset("assets/done_button.png"))
                    : GestureDetector(
                        onTap: () {
                          ref.read(playersProvider.notifier).state = [];
                          for (Player p in args) {
                            ref.read(playersProvider.notifier).add(p);
                          }
                          addNewRound(Gargs);
                          ref.read(biddingProvider.notifier).state = !biddingW;
                        },
                        child: Image.asset("assets/add_button.png"));
              })),
        ),
      ],
    ));
  }

  Future<void> addNewRound(List<Player> args) async {
    try {
      List<inGamePlayer> newRound = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return alert(args);
        },
      );
      setState(() {
        print("adding round...........");
        if (newRound != null) {
          rounds.add(newRound);
        } else {
          ref.read(biddingProvider.notifier).state = false;
        }
      });
      print(rounds.length);
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
          //barrierDismissible: false,
          context: context,
          builder: (_) {
            return alert2(round);
          });
      List<int> latest = roundsScores.last;
      List<int> newScore = alerty.map((e) => e.score).toList();
      List<int> upScore = [0, 0, 0, 0];
      for (int i = 0; i < 4; ++i) {
        upScore[i] = latest[i] + newScore[i];
      }

      setState(() {
        roundsScores.add(upScore);
        updateRanks();
      });
    } catch (e) {
      print("nothing");
      ref.read(biddingProvider.notifier).state =
          !ref.read(biddingProvider.notifier).state;
    }
  }

  String returnRiskSymbol(String risk) {
    if (risk == 'Risk') return 'R';
    if (risk == '2x Risk') return '2R';
    if (risk == '3x Risk') return '3R';
    return ' ';
  }
}

void updateRanks() {
  kingIndx = roundsScores.last.indexOf(roundsScores.last.max);
  kuuzIndx = roundsScores.last.indexOf(roundsScores.last.min);
  print("KingIndex: " + kingIndx.toString());
  print("kuuzIndex: " + kuuzIndx.toString());
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

  List<FocusNode> focusList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  @override
  Widget build(BuildContext context) {
    var rnd = widget.rnd;
    final sz = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
        title: const Text(
          "End Round",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(224, 40, 74, 1.0),
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
            PageController _pageContt = PageController(viewportFraction: 0.7);
            final players = ref.watch(playersProvider.notifier);
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return GestureDetector(
                  onTap: () {
                    print("taaaaaaaap");
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: sz.height * 0.25,
                    width: sz.width / 1.5,
                    child: Form(
                      key: formKey,
                      child: PageView.builder(
                          allowImplicitScrolling: true,
                          onPageChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(focusList[value]);
                          },
                          controller: _pageContt,
                          itemCount: 4,
                          itemBuilder: (_, indx) {
                            return SingleChildScrollView(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                //width: sz.width * 0.8,
                                //height: sz.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                224, 40, 74, 1.0),
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
                                            Gargs[indx].name,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  224, 40, 74, 1.0),
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
                                    Stack(
                                      fit: StackFit.loose,
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            focusNode: focusList[indx],
                                            autofocus: true,
                                            onFieldSubmitted: ((value) {
                                              goNextPage(_pageContt);
                                            }),
                                            onChanged: (res) {},
                                            style: const TextStyle(
                                              fontFamily: "Lucida",
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.start,
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
                                                    224, 40, 74, 1.0),
                                                fontFamily: "Lucida",
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 25),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                "/ " + rnd[indx].bid.toString(),
                                                style: const TextStyle(
                                                  fontFamily: "Lucida",
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color.fromRGBO(
                                                            224, 40, 74, 1.0)),
                                                shape: MaterialStateProperty.all(
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(15.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  40.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  40.0)),
                                                ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: indx != 3
                                          ? (() {
                                              goNextPage(_pageContt);
                                            })
                                          : () async {
                                              await endScoring(rnd, context);
                                            },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
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
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromRGBO(
                                                      224, 40, 74, 1.0)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ))),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                );
              },
            );
          },
        ));
    return alert;
  }

  void goNextPage(PageController _pageContt) {
    _pageContt.animateToPage((_pageContt.page! + 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Future<void> endScoring(List<inGamePlayer> rnd, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      int sum = 0;
      for (TextEditingController call in calls) {
        sum += int.parse(call.text);
      }
      if (sum != 13) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: "sum of all bids must be 13",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 18,
            backgroundColor: const Color.fromRGBO(224, 40, 74, 0.5));
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
            //continue;
          } else if (rnd[i].bid >= 8) {
            //Big Calls
            rnd[i].score -= (pow(rnd[i].bid, 2) / 2).round();
            //continue;
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

  List<FocusNode> focusList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  @override
  Widget build(BuildContext context) {
    print("building alert");
    final sz = MediaQuery.of(context).size;

    AlertDialog alert = AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 32),
              child: const Text(
                "New Round",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(224, 40, 74, 1.0),
                  fontFamily: "Lucida",
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close))
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        content: Consumer(
          builder: (ctx, ref, ch) {
            final players = ref.watch(playersProvider.notifier);
            return Builder(
              builder: (BuildContext context) {
                var colors = [
                  'No Trump',
                  'spades',
                  'hearts',
                  'diamonds',
                  'clubs'
                ];
                var riskStatus = ['No Risk', 'Risk', '2x Risk', '3x Risk'];
                PageController _pageCont =
                    PageController(viewportFraction: 0.7);
                return Container(
                  height: sz.height * 0.44,
                  width: sz.width / 1.5,
                  child: PageView.builder(
                      allowImplicitScrolling: true,
                      onPageChanged: (value) {
                        FocusScope.of(context).requestFocus(focusList[value]);
                      },
                      controller: _pageCont,
                      itemCount: 4,
                      itemBuilder: (_, indx) {
                        return SingleChildScrollView(
                          child: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              key: formKeys[indx],
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                //width: sz.width * 0.8,
                                //height: sz.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                224, 40, 74, 1.0),
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
                                            Gargs[indx].name + "\n's Bid",
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  224, 40, 74, 1.0),
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
                                      margin: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        focusNode: focusList[indx],
                                        autofocus: /*indx == 0 ? true : false*/ true,
                                        onFieldSubmitted: (value) {
                                          focusList[indx].unfocus();
                                        },
                                        //enabled: true,
                                        onChanged: (res) {
                                          try {
                                            ref
                                                .read(playersProvider.notifier)
                                                .setBid(indx, int.parse(res));
                                            //focusList[indx].unfocus();
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        style: const TextStyle(
                                          fontFamily: "Lucida",
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                        controller: calls[indx],
                                        validator: (s) {
                                          try {
                                            if (int.parse(s!) > 13)
                                              return "Can't be more than 13";
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          labelText: "Number of tricks ordered",
                                          labelStyle: const TextStyle(
                                            color: Color.fromRGBO(
                                                224, 40, 74, 1.0),
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
                                                  224, 40, 74, 1.0),
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
                                          //autofocus: true,
                                          onChanged: (val) {
                                            //FocusScope.of(context).unfocus();
                                            setState(
                                              () {
                                                ref
                                                    .read(playersProvider
                                                        .notifier)
                                                    .toggleIsCall(indx);
                                              },
                                            );
                                          }),
                                    ),
                                    players.state[indx].isCall &&
                                            players.state[indx].bid != 0
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
                                              setState(() {
                                                ref
                                                    .read(playersProvider
                                                        .notifier)
                                                    .setOColor(indx,
                                                        newVal.toString());
                                              });
                                            })
                                        : const Divider(),
                                    Container(
                                      width: sz.width * 0.6,
                                      child: SwitchListTile.adaptive(
                                          title: const Text(
                                            "Is With",
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  224, 40, 74, 1.0),
                                              fontFamily: "Lucida",
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          value: players.state[indx].isWith,
                                          onChanged: (val) {
                                            setState(() {
                                              ref
                                                  .read(
                                                      playersProvider.notifier)
                                                  .toggleIsWith(indx);
                                            });
                                          }),
                                    ),
                                    DropdownButton(
                                      borderRadius: BorderRadius.circular(40.0),
                                      value: players.state[indx].risk,
                                      items: riskStatus.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          ref
                                              .read(playersProvider.notifier)
                                              .setRisk(indx, newVal.toString());
                                        });
                                      },
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          indx != 3
                                              ? nextPage(_pageCont)
                                              : endBidding(players, context);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
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
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromRGBO(
                                                        224, 40, 74, 1.0)),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                            ))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                );
              },
            );
          },
        ));
    return alert;
  }

  void endBidding(gamePlayers players, BuildContext context) {
    if (players.getSumBids() == 13) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "sum of all bids can't be 13",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 18,
          backgroundColor: const Color.fromRGBO(224, 40, 74, 0.5));
    } else {
      List<inGamePlayer> round = players.state;
      Navigator.pop(context, round);
    }
  }

  void nextPage(PageController _pageCont) {
    _pageCont.animateToPage((_pageCont.page! + 1.0).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  bool get wantKeepAlive => true;
}
