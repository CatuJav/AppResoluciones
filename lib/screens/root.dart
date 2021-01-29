import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisei_administrativo/screens/bienvenida.dart';
import 'package:fisei_administrativo/screens/home.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BienvenidaPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
