import 'package:flutter/material.dart';
import 'package:flutter_animation/screens/implicit_animations_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Flutter Animation"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  ImplicitAnimationsScreen(),
                );
              },
              child: Text(
                "Implicit Animations",
              ),
            )
          ],
        ),
      ),
    );
  }
}
