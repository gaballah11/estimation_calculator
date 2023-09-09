import 'package:estimation_calculator/modules/theme.dart';
import 'package:estimation_calculator/screens/players.dart';
import 'package:estimation_calculator/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  bool touched = false;
  bool visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: Consumer(builder: (context, ref, _) {
        return Stack(
          fit: StackFit.loose,
          children: [
            Container(
              width: sz.width,
              height: sz.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 0, 0, 0),
                  Color.fromRGBO(224, 40, 74, 0.5)
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
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/bottom.png"),
            ),
            ref.watch(themeProvider) != ThemeMode.system
                ? AnimatedOpacity(
                    opacity: visible ? 1.0 : 0.0,
                    duration: Duration(seconds: 2),
                    child: Align(
                        alignment: const Alignment(0.9, -0.9),
                        child: IconButton(
                          iconSize: 40,
                          onPressed: () {
                            ref.watch(themeProvider) == ThemeMode.dark
                                ? ref
                                    .read(themeProvider.notifier)
                                    .changeTheme(ThemeMode.light)
                                : ref
                                    .read(themeProvider.notifier)
                                    .changeTheme(ThemeMode.dark);
                          },
                          icon: ref.watch(themeProvider) == ThemeMode.dark
                              ? Icon(Icons.light_mode)
                              : Icon(Icons.dark_mode),
                        )),
                  )
                : Container(),
            AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
              child: Align(
                  alignment: const Alignment(0, -0.6),
                  child: Image.asset(
                    "assets/logo-01.png",
                  )),
            ),
            AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: Duration(seconds: 3),
              child: Align(
                alignment: const Alignment(0, -0.02),
                child: Text(
                  " ",
                  style: TextStyle(
                    //color: Colors.red,
                    fontFamily: "Lucida",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
              child: Align(
                child: Container(
                    margin: EdgeInsets.only(top: 200),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(playersSc.routename);
                      },
                      child: Image.asset(
                        "assets/start_button.png",
                        width: 280,
                      ),
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }
}
