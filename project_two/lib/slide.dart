import 'dart:async';
import 'dart:math' as math;
import 'login.dart';
import 'package:flutter/material.dart';

/// This is the main application widget.
class test2 extends StatelessWidget {
  const test2({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  late Animation _translateAnimation =
      Tween<Offset>(begin: Offset(0, 275), end: Offset(110, 275))
          .animate(_animationController);

  late AnimationController _animationController2 = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  late Animation _translateAnimation2 =
      Tween<Offset>(begin: Offset(325, 275), end: Offset(190, 275))
          .animate(_animationController2);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 6000), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.yellow[600],
        child: Stack(
          children: [
            Container(
              child: Image.asset(
                'assets/images/map.png',
                height: 1200,
                width: 1000,
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              child: Container(
                child: Image.asset(
                  'assets/images/run22.png',
                  height: 190,
                  width: 100,
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: _translateAnimation.value,
                  child: child,
                );
              },
            ),
            AnimatedBuilder(
              animation: _animationController2,
              child: Container(
                child: Image.asset(
                  'assets/images/run.png',
                  height: 190,
                  width: 100,
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: _translateAnimation2.value,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
