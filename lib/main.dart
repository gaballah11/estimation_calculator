import 'package:estimation_calculator/modules/theme.dart';
import 'package:estimation_calculator/screens/home.dart';
import 'package:estimation_calculator/screens/players.dart';
import 'package:estimation_calculator/screens/game.dart';
import 'package:estimation_calculator/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  _MyAppState();

  @override
  Widget build(BuildContext context) {
    var themeState = ref.watch(themeProvider);
    return Consumer(
      builder: (context, ref, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Estimation Calculator',
          routes: {
            playersSc.routename: (context) => playersSc(),
            gameSc.routename: (context) => gameSc(),
            settingSc.routename: (context) => settingSc(),
          },
          themeMode: themeState,
          darkTheme: ThemeData(
              colorSchemeSeed: Color.fromRGBO(180, 25, 53, 0.498),
              //switchTheme: SwitchThemeData(),
              brightness: Brightness.dark,
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(224, 40, 74, 1.0)),
              ))),
          theme: ThemeData(
            //useMaterial3: true,
            colorSchemeSeed: Color.fromRGBO(224, 40, 74, 1.0),
          ),
          home: const MyHomePage(),
        );
      },
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
