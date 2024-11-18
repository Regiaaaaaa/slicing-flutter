import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    _controller?.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  } // Tutup bracket untuk initState di sini

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/newlogo.png', width: 300, height: 200),
              SizedBox(height: 20),
              Text(
                'Frech',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 60, 255),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}