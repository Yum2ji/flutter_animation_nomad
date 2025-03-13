import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  //SingleTickerProviderStateMixin 또는 TickerProviderStateMixin
/*   late final AnimationController _animationController = AnimationController(
    vsync: this,// SingleTickerProviderStateMixin의 Ticker와 바로 연결되는부분
    duration: Duration(
      seconds: 10,
    ),
    lowerBound: 50.0,
    upperBound: 100.0,
  )..addListener(
      () {
        //build 메서드 전체가 만들어짐
        setState(() {});
      },
    );  */
  late final AnimationController _animationController = AnimationController(
    vsync: this, // SingleTickerProviderStateMixin의 Ticker와 바로 연결되는부분
    duration: Duration(
      seconds: 2,
    ),
  );

  // Animationcontroller 만 사용해 animation 조절하면 0~1 과 같이만 조절 color 같은거는 어렵기 때문에 아래의 Tween 사용
  late final Animation<Color?> _color = ColorTween(
    begin: Colors.amber,
    end: Colors.red,
  ).animate(_animationController);

  @override
  void initState() {
    super.initState();
/*     Timer.periodic(
        Duration(
          milliseconds: 500,
        ), (timer) {
      print(_animationController.value);
    }); */

    /* 
    //아래와 같이 Ticker를 만들면 user가 이 화면에서 벗어났을 때에도실행됨
    //State 만들 때 with SingleTickerProviderStateMixin 으로 하는 이유유
    Ticker(
      (elapsed) => print(elapsed),
    ).start(); 
    */
  }

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Explicit Animations",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //AnimatedBuilder로 하면 _animationController.addLister로 setstate하는 것과 다르게 딱 이부분만 build 되도록 해줌.
            AnimatedBuilder(
              animation: _color,
              builder: (context, child) {
                return Container(
                  color: _color.value,
                  width: 400,
                  height: 400,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: Text(
                    "play",
                  ),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: Text(
                    "pause",
                  ),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: Text(
                    "rewind",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
