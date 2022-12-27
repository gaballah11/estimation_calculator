import 'package:estimation_calculator/screens/players.dart';
import 'package:estimation_calculator/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: Stack(
        fit: StackFit.loose,
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
            alignment: Alignment.topCenter,
            child: Image.asset("assets/top.png"),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/bottom.png"),
          ),
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
            duration: Duration(seconds: 2),
            child: Align(
              child: Container(
                margin: EdgeInsets.only(top: 200),
                child: button(
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: (sz.width / 10) * 2,
                    ), () {
                  print("button pressed");
                  Navigator.of(context).pushNamed(playersSc.routename);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
