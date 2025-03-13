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
    reverseDuration: Duration(
      seconds: 1,
    ),
  )..addListener(
      () {
        _range.value = _animationController.value;
      },
    );
/*     ..addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      },
    ); */

  // Animationcontroller 만 사용해 animation 조절하면 0~1 과 같이만 조절 color 같은거는 어렵기 때문에 아래의 Tween 사용
/*   late final Animation<Color?> _color = ColorTween(
    begin: Colors.amber,
    end: Colors.red,
  ).animate(_animationController);
 */
  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_curve);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_curve);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.1,
  ).animate(_curve);

  late final Animation<Offset> _position = Tween(
    begin: Offset.zero,
    end: Offset(0, -0.2),
  ).animate(_curve);

  //late 안쓰면안됨 _animationController가 late로 정의되어있으니까
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceIn,
  );

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

  @override
  void dispose() {
    _animationController.dispose(); //animation 진행중에 뒤로가기 눌러버리면 error 나는
    super.dispose();
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

  // double _value =0.0 과 같이 하지 않음. valueNotifier로 하는.setstate 하지 않아도 됨. build method를 거치지 않고도 변경된 부분을 잘 알아채는
  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChanged(double value) {
/*  
  ValueNotifier로 바뀌면 setstate안쓰게 됨.
   setState(() {
      _value = value;
    }); */
    _range.value = 0;

    //이렇게 하면 animation 없이 값만 바꾸는는
    _animationController.value = value;
    //아래 내용은  animation됨.
    //_animationController.animateTo(value);
  }

  bool _looping = false;
  void _toggleLooping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat(
        reverse: true,
      );
    }
    setState(() {
      _looping = !_looping;
    });
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
            /* AnimatedBuilder(
              animation: _color,
              builder: (context, child) {
                return Container(
                  color: _color.value,
                  width: 400,
                  height: 400,
                );
              },
            ),
            */

            //ExplicitWidget
            SlideTransition(
              position: _position,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: SizedBox(
                      height: 400,
                      width: 400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
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
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(
                    _looping ? "Stop looping" : "Start looping",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(
                  value: value,
                  onChanged: _onChanged,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
