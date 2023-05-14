import 'package:flutter/material.dart';

class button extends StatefulWidget {
  final todo;
  final Widget icon;
  const button(this.icon,this.todo,{Key? key}) : super(key: key);

  @override
  _buttonState createState() => _buttonState(icon,todo);
}

class _buttonState extends State<button> {
  bool touched = false;
  final _todo;
  final Widget _icon;
  _buttonState(this._icon,this._todo);

  @override
  Widget build(BuildContext context) {
    //print("building button.....");
    return AnimatedContainer(
      duration: Duration(seconds: 2),

      child: GestureDetector(
        onLongPressDown: (press) {
          setState(() {
            touched = true;
          });
        },
        onLongPressEnd: (press) {
          setState(() {
            touched = false;
          });
        },
        onTap: () {
          setState(() {
            touched = !touched;
          });
          Future.delayed(Duration(milliseconds: 300), (){
            _todo();
          });

        },
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            touched
                ? Image.asset(
              "assets/pressed.png",
              width: 120,
              height: 120,
            )
                : Image.asset(
              "assets/button.png",
              width: 120,
              height: 120,
            ),
            Container(
              margin: !touched?EdgeInsets.only(right: 10,bottom: 20):EdgeInsets.only(right: 10,bottom: 5),
              child: _icon,
            )
          ],
        ),
      ),
    );
  }
}
