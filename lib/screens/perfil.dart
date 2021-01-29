import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisei_administrativo/screens/bienvenida.dart';
import 'package:fisei_administrativo/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({Key key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Map<String, dynamic> _infoEstudie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _infoEstudie = jsonDecode(prefs.getString('info_estudiante'));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _infoEstudie != null
          ? ListView(
              children: [
                ListTile(
                  title: Text(
                    'Nombres',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _infoEstudie['nombres'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                Divider(
                  height: 1.5,
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    'Apellidos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _infoEstudie['apellidos'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                Divider(
                  height: 1.5,
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    'Cédula',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _infoEstudie['cedula'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                Divider(
                  height: 1.5,
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    'Correo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _infoEstudie['correo'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                Divider(
                  height: 1.5,
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    'Correo UTA',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _infoEstudie['correoUTA'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                Divider(
                  height: 1.5,
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    'Folio',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _infoEstudie['folio'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                Divider(
                  height: 1.5,
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    'Matrícula',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _infoEstudie['matricula'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                Divider(
                  height: 1.5,
                  thickness: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()));
                    },
                    child: Text('CERRAR SESIÓN',
                        style: TextStyle(color: Color(0XFF781617))))
              ],
            )
          : Container(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0XFF781617),
        title: Text('PERFIL'),
      ),
    );
  }
}
