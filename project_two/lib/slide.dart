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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('중간 가즈아'),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              child: Image.asset(
                'assets/images/giphy.gif',
                height: 1000,
                width: 1000,
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              child: Container(
                child: Image.asset(
                  'assets/images/run22.png',
                  height: 100,
                  width: 100,
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: _translateAnimation.value,
                  child: child,
                );
                // return Transform.scale(
                //   scale: _scaleAnimation.value,
                //   child: Transform.rotate(
                //     angle: _rotateAnimation.value,
                //     child: child,
                //   ),
                // );
              },
            ),
            AnimatedBuilder(
              animation: _animationController2,
              child: Container(
                child: Image.asset(
                  'assets/images/run.png',
                  height: 100,
                  width: 100,
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: _translateAnimation2.value,
                  child: child,
                );
                // return Transform.scale(
                //   scale: _scaleAnimation.value,
                //   child: Transform.rotate(
                //     angle: _rotateAnimation.value,
                //     child: child,
                //   ),
                // );
              },
            ),
            Positioned(
              bottom: 40,
              right: 155,
              child: Container(
                child: ElevatedButton(
                  child: Text('테스트 시작'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
