import 'package:shared_preferences/shared_preferences.dart';

class scoring {
  late int dashWinUnder;
  late int dashWinOver;
  late int dashLoseUnder;
  late int dashLoseOver;
  late int win;
  late int lose;
  late int onlyWin;
  late int onlyLose;

  late bool doubleThreeCalls;

  scoring() {
    initializeVarZero();
    print("Scoring constructor");
    getScoringFromDb().then((value) {
      if (value == false) {
        print("cococococococococ");
        resetToDefault();
      }
    });
  }

  resetToDefault() {
    print("Reset to default");
    dashWinUnder = 33;
    dashWinOver = 23;
    dashLoseUnder = 23;
    dashLoseOver = 33;
    win = 13;
    lose = 0;
    onlyWin = 10;
    onlyLose = 10;

    doubleThreeCalls = true;

    addScoringToDb();
  }

  Future<void> addScoringToDb() async {
    print("adding to DB");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("dashWinUnder", dashWinUnder);
    prefs.setInt("dashWinOver", dashWinOver);
    prefs.setInt("dashLoseOver", dashLoseOver);
    prefs.setInt("dashLoseUnder", dashLoseUnder);
    prefs.setInt("lose", lose);
    prefs.setInt("onlyLose", onlyLose);
    prefs.setInt("onlyWin", onlyWin);
    prefs.setInt("win", win);

    prefs.setBool("doubleThreeCalls", doubleThreeCalls);
  }

  Future<bool> getScoringFromDb() async {
    print("get from db");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("win")) {
      print("true");
      dashWinUnder = prefs.getInt("dashWinUnder")!;
      dashWinOver = prefs.getInt("dashWinOver")!;
      dashLoseOver = prefs.getInt("dashLoseOver")!;
      dashLoseUnder = prefs.getInt("dashLoseUnder")!;
      lose = prefs.getInt("lose")!;
      onlyLose = prefs.getInt("onlyLose")!;
      onlyWin = prefs.getInt("onlyWin")!;
      win = prefs.getInt("win")!;

      doubleThreeCalls = prefs.getBool("doubleThreeCalls")!;
      return true;
    } else {
      print(false);
      return false;
    }
  }

  void initializeVarZero() {
    dashWinUnder = 0;
    dashWinOver = 0;
    dashLoseUnder = 0;
    dashLoseOver = 0;
    win = 0;
    lose = 0;
    onlyWin = 0;
    onlyLose = 0;

    doubleThreeCalls = false;
  }

  void printing() {
    print('scoring system :');
    print(dashLoseOver);
    print(dashLoseUnder);
    print(dashWinOver);
    print(dashWinUnder);
    print(doubleThreeCalls);
    print(lose);
    print(onlyLose);
    print(onlyWin);
    print(win);
    print('_____________________');
  }
}
