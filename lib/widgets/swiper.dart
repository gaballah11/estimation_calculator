import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class charachterSwiper extends StatefulWidget {
  Size siz;

  charachterSwiper(this.siz, {Key? key}) : super(key: key);

  @override
  charachterSwiperState createState() => charachterSwiperState(siz);
}

class charachterSwiperState extends State<charachterSwiper> {
  Size sz;
  List<String> charList = [];
  int currentIndex = 0;

  charachterSwiperState(this.sz);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
    for (int i = 1; i <= 19; ++i) {
      charList.add("assets/charachters/$i.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sz.height / 4.5,
      width: sz.width / 1.5,
      child: PageView.builder(
          //allowImplicitScrolling: false,
          controller: PageController(viewportFraction: 0.5, initialPage: 19),
          //itemCount: 19,
          itemBuilder: (_, curr) {
            currentIndex = curr - 1;
            return Image.asset(charList[curr % 19]);
          }),
    );
  }
}

/*Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [

GestureDetector(
onHorizontalDragUpdate: (details){
if(details.delta.dx<0){


if(details.delta.dx<-5.0){
//print(details.delta.dx);
setState(() {
currentIndex==18?currentIndex =0:currentIndex +=1;
//currentIndex  %= charList.length;
});
}

}
else if(details.delta.dx>0){
if(details.delta.dx>5.0){
print(details.delta.dx);
setState(() {
currentIndex==0?currentIndex =18:currentIndex -=1;
//currentIndex  %= charList.length;
});
}

}
},
onHorizontalDragEnd: (DragEndDetails details){
print(details.velocity);
},
child: Stack(
alignment: Alignment(0.0,1.0),
children: [

Opacity(
opacity: 0.4,
child: Align(
alignment: Alignment(-1.0,1.0),
child: currentIndex == 0?
Image.asset(charList.last, height: sz.height/7,)
:Image.asset(charList[currentIndex-1], height: sz.height/7),
),
),


Opacity(
opacity: 0.4,
child: Align(
alignment: Alignment(1.0,1.0),
child: currentIndex == charList.length-1?
Image.asset(charList.first, height: sz.height/7)
:Image.asset(charList[currentIndex+1], height: sz.height/7),
),
),



Image.asset(charList[currentIndex], height: sz.height/4),
],
),
),

Row(
crossAxisAlignment: CrossAxisAlignment.center,
mainAxisAlignment: MainAxisAlignment.center,
children: [
GestureDetector(
onTap: (){
setState(() {
currentIndex == 0? currentIndex = 18 : currentIndex = currentIndex-1;
});
},
child: Padding(
padding: const EdgeInsets.all(8.0),
child: Icon(Icons.arrow_left_rounded, size: sz.width/7,),
),
),
SizedBox(width: sz.width/8,),
GestureDetector(
onTap: (){
setState(() {
currentIndex == 18? currentIndex = 0 : currentIndex = currentIndex+1;
});
},
child: Padding(
padding: const EdgeInsets.all(8.0),
child: Icon(Icons.arrow_right_rounded, size: sz.width/7),
),
),




],
),

],
)*/
