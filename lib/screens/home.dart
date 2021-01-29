import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fisei_administrativo/screens/historial.dart';
import 'package:fisei_administrativo/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initFCM();
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> datos = jsonDecode(prefs.getString('info_estudiante'));
    var sn =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (sn.exists) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    } else {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'nombre': datos['nombres'].split(' ')[0],
        'cedula': datos['cedula'],
        'tokens': [token],
      });
    }
  }

  void initFCM() async {
    String token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? HistorialPage() : PerfilPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Color(0XFF781617),
        selectedLabelStyle:
            TextStyle(color: Color(0XFF781617), fontWeight: FontWeight.bold),
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Mis Resoluiones',
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: 'Perfil',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
