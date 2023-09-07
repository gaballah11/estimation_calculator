import 'package:flutter/material.dart';

class button extends StatefulWidget {
  String title;
  final todo;
  final Widget icon;
  button(this.title, this.icon, this.todo, {Key? key}) : super(key: key);

  @override
  _buttonState createState() => _buttonState(title, icon, todo);
}

class _buttonState extends State<button> {
  String title;
  bool touched = false;
  final _todo;
  final Widget _icon;
  _buttonState(this.title, this._icon, this._todo);

  @override
  Widget build(BuildContext context) {
    //print("building button.....");
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
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
          Future.delayed(Duration(milliseconds: 300), () {
            _todo();
          });
        },
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.topCenter,
          children: [
            touched
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Image.asset(
                      "assets/pressed.png",
                      width: 120,
                      height: 120,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Image.asset(
                      "assets/button.png",
                      width: 120,
                      height: 120,
                    ),
                  ),
            Container(
              margin: !touched
                  ? EdgeInsets.only(top: 25, right: 10, bottom: 20)
                  : EdgeInsets.only(top: 25, right: 10, bottom: 5),
              child: _icon,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 0, 3, 0.4),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Text(
                  title,
                  style: const TextStyle(
                    overflow: TextOverflow.clip,
                    color: Colors.white,
                    fontFamily: "Lucida",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
