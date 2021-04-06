import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passwordreminderrd/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password',
      home: Splash(
        title: "Password",
      ),
    );
  }
}

class Splash extends StatefulWidget {
  Splash({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Container(
          child: Center(
            child: Container(
              width: width / 1.2,
              height: width / 1.2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/logosplash.png'),
                fit: BoxFit.cover,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
