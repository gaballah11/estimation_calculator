import 'package:estimation_calculator/modules/scoring.dart';
import 'package:estimation_calculator/modules/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class settingSc extends StatefulWidget {
  static const routename = '/settings';
  const settingSc({Key? key}) : super(key: key);

  @override
  _settingScState createState() => _settingScState();
}

class _settingScState extends State<settingSc> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dashWinUnder = new TextEditingController();
  TextEditingController dashWinOver = new TextEditingController();
  TextEditingController dashLoseUnder = new TextEditingController();
  TextEditingController dashLoseOver = new TextEditingController();
  TextEditingController win = new TextEditingController();
  TextEditingController lose = new TextEditingController();
  TextEditingController onlyWin = new TextEditingController();
  TextEditingController onlyLose = new TextEditingController();
  bool _doubleThreeCalls = false;

  late scoring score;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    print("init setting");

    waitForScore().then((value) {
      print("asdsadsadasd");
      changeControllers();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: [
        Align(
            alignment: const Alignment(0, -0.9),
            child: Image.asset(
              "assets/logo-01.png",
              width: sz.width / 1.7,
            )),
        Container(
            margin: EdgeInsets.only(top: sz.height * 0.175),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      "Scoring system",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Lucida",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    leading: const Icon(
                      Icons.paste_rounded,
                      color: Colors.red,
                    ),
                    onTap: () {
                      showScoringAlert(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "Theme",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Lucida",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    leading: const Icon(
                      Icons.brush_rounded,
                      color: Colors.red,
                    ),
                    onTap: () {
                      showThemeAlert(context);
                    },
                  )
                ],
              ),
            )),
      ],
    ));
  }

  Future<void> showThemeAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return themeAlert();
      },
    );
  }

  Future<void> showScoringAlert(BuildContext context) async {
    final sz = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Scoring System",
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
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(width: 800),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildInputLabel("Win Score", win),
                    buildInputLabel("Lose Score", lose),
                    buildInputLabel("Only Win Score", onlyWin),
                    buildInputLabel("Only Lose Score", onlyLose),
                    buildInputLabel(
                        "Dash call Wins in Under Score", dashWinUnder),
                    buildInputLabel(
                        "Dash call Wins in Over Score", dashWinOver),
                    buildInputLabel(
                        "Dash call Loses in Under Score", dashLoseUnder),
                    buildInputLabel(
                        "Dash call Loses in Over Score", dashLoseOver),
                    SwitchListTile(
                        title: const Text(
                          "Double when Three Calls",
                          style: TextStyle(
                            color: Color.fromRGBO(200, 0, 3, 1.0),
                            fontFamily: "Lucida",
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        value: _doubleThreeCalls,
                        onChanged: (val) {
                          setState(() {
                            _doubleThreeCalls = val;
                          });
                        })
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            score.resetToDefault();
            setState(() {
              changeControllers();
            });
          },
          child: const Text(
            "Reset to default",
            style: TextStyle(
              //color: Colors.red,
              fontFamily: "Lucida",
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              score.dashWinUnder = int.parse(dashWinUnder.text);
              score.dashWinOver = int.parse(dashWinOver.text);
              score.dashLoseUnder = int.parse(dashLoseUnder.text);
              score.dashLoseOver = int.parse(dashLoseOver.text);
              score.win = int.parse(win.text);
              score.lose = int.parse(lose.text);
              score.onlyWin = int.parse(onlyWin.text);
              score.onlyLose = int.parse(onlyLose.text);
              score.doubleThreeCalls = _doubleThreeCalls;

              score.addScoringToDb();

              Navigator.of(context).pop();
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
              //backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              //color: Colors.red,
              fontFamily: "Lucida",
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> waitForScore() async {
    score = new scoring();
  }

  void changeControllers() {
    dashWinUnder.text = score.dashWinUnder.toString();
    dashWinOver.text = score.dashWinOver.toString();
    dashLoseUnder.text = score.dashLoseUnder.toString();
    dashLoseOver.text = score.dashLoseOver.toString();
    win.text = score.win.toString();
    lose.text = score.lose.toString();
    onlyWin.text = score.onlyWin.toString();
    onlyLose.text = score.onlyLose.toString();
    _doubleThreeCalls = score.doubleThreeCalls;
  }
}

class themeAlert extends ConsumerStatefulWidget {
  themeAlert();

  @override
  themeAlertState createState() {
    return new themeAlertState();
  }
}

class themeAlertState extends ConsumerState<themeAlert>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Theme",
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
      content: Consumer(
        builder: (context, ref, _) {
          ThemeMode themeVal = ref.read(themeProvider.notifier).state;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: RadioListTile<ThemeMode>(
                  onChanged: (value) {
                    setState(() {
                      themeVal = value!;
                      ref.read(themeProvider.notifier).changeTheme(themeVal);
                    });
                  },
                  value: ThemeMode.system,
                  groupValue: themeVal,
                  title: Text("System Theme"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RadioListTile<ThemeMode>(
                  onChanged: (value) {
                    setState(() {
                      themeVal = value!;
                      ref.read(themeProvider.notifier).changeTheme(themeVal);
                    });
                    print(ref.read(themeProvider.notifier).state);
                  },
                  value: ThemeMode.light,
                  groupValue: themeVal,
                  title: Text("light Theme"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RadioListTile<ThemeMode>(
                  onChanged: (value) {
                    setState(() {
                      themeVal = value!;
                      ref.read(themeProvider.notifier).changeTheme(themeVal);
                    });
                  },
                  value: ThemeMode.dark,
                  groupValue: themeVal,
                  title: Text("dark Theme"),
                ),
              ),
            ],
          );
        },
      ),
    );
    return alert;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

buildInputLabel(String s, TextEditingController win) {
  return Container(
    margin: EdgeInsets.all(10),
    child: TextFormField(
      style: TextStyle(
        fontFamily: "Lucida",
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
      controller: win,
      validator: (s) {
        if (s!.length == 0) return "Field mustn't be empty";
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        labelText: s,
        labelStyle: const TextStyle(
          color: Color.fromRGBO(200, 0, 3, 1.0),
          fontFamily: "Lucida",
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    ),
  );
}
