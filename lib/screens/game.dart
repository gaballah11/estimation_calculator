import 'package:estimation_calculator/modules/player.dart';
import 'package:flutter/cupertino.dart';

class gameSc extends StatefulWidget {
  static const routename = '/game';
  const gameSc({Key? key}) : super(key: key);

  @override
  _gameScState createState() => _gameScState();
}

class _gameScState extends State<gameSc> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<Player>;

    return Column(
      children: args.map((e) => Text(e.name)).toList(),
    );
  }
}
