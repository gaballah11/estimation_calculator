import 'package:estimation_calculator/screens/home.dart';
import 'package:estimation_calculator/screens/players.dart';
import 'package:estimation_calculator/screens/game.dart';
import 'package:estimation_calculator/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Estimation Calculator',
      routes: {
        playersSc.routename: (context) => playersSc(),
        gameSc.routename: (context) => gameSc(),
        settingSc.routename : (context) => settingSc(),
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const homeScreen();
  }
}
