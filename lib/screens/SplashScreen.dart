import 'package:flutter/material.dart';
import 'AWalkThroughScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AWalkThroughScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Text('Customer', style: TextStyle(fontSize: 45))),
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'image/appetit/pizza2.png',
              fit: BoxFit.cover,
              height: 120,
              width: 120,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'image/appetit/pizza1.png',
              fit: BoxFit.cover,
              height: 130,
              width: 130,
            ),
          ),
        ],
      ),
    );
  }
}
