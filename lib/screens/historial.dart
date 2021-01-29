import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HistorialPage extends StatefulWidget {
  HistorialPage({Key key}) : super(key: key);

  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<dynamic> _resoluciones = [];
  List<String> _meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre'
  ];
  @override
  void initState() {
    super.initState();
    actualizarListado();
  }

  void actualizarListado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> infoEstudie =
        jsonDecode(prefs.getString('info_estudiante'));

    try {
      var response = await http.get(
          'http://40.74.242.68/api/resoluciones/estudiante/' +
              infoEstudie['cedula']);
      print('http://40.74.242.68/api/resoluciones/estudiante/' +
          infoEstudie['cedula']);
      if (response.statusCode != 200) {
        Toast.show('Estudiante no encontrado', context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG,
            backgroundColor: Color(0XFFFF4365));
        return;
      } else {
        _resoluciones = jsonDecode(response.body);
        if (mounted) setState(() {});
      }
    } catch (e) {
      print(e);
      Toast.show('Upps! Hubo un error', context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Color(0XFFFF4365));
      return;
    }
    print(_resoluciones);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _resoluciones.map((e) {
      DateTime fecha = DateTime.parse(e['created_at']);

      return Column(
        children: [
          ListTile(
            title: Text(
                e['nummero_resolucion'].toString() +
                    '-P-CD-FISEI-' +
                    fecha.year.toString(),
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(fecha.day.toString() +
                ' ' +
                _meses[fecha.month - 1] +
                ' de ' +
                fecha.year.toString()),
          ),
          Divider(
            thickness: 1,
          )
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                actualizarListado();
              })
        ],
        centerTitle: true,
        backgroundColor: Color(0XFF781617),
        title: Text('HISTORIAL'),
      ),
      body: ListView(
        children: children,
      ),
    );
  }
}
