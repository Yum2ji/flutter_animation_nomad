import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;
  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Implicit Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
/*             AnimatedAlign(
              alignment: _visible ? Alignment.topLeft : Alignment.topRight,
              duration: Duration(seconds: 2),
              child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: _visible ? 1 : 0.2,
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  color: Colors.amber,
                ),
              ),
            ), */
            AnimatedContainer(
              curve: Curves.elasticOut,
              duration: Duration(
                seconds: 2,
              ),
              width: size.width * 0.8,
              height: size.width * 0.8,
              transform: Matrix4.rotationZ(
                _visible ? 1 : 0,
              ),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.red : Colors.amber,
                borderRadius: BorderRadius.circular(_visible ? 100 : 0),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: _trigger,
              child: Text("Go!"),
            ),
          ],
        ),
      ),
    );
  }
}
