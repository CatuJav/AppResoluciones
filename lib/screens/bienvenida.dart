import 'package:concentric_transition/page_route.dart';
import 'package:concentric_transition/page_view.dart';
import 'package:fisei_administrativo/screens/login.dart';
import 'package:flutter/material.dart';

class BienvenidaPage extends StatefulWidget {
  BienvenidaPage({Key key}) : super(key: key);

  @override
  _BienvenidaPageState createState() => _BienvenidaPageState();
}

class _BienvenidaPageState extends State<BienvenidaPage> {
  PageController pc = PageController();

  @override
  void initState() {
    super.initState();

    pc.addListener(() {
      if (pc.offset > MediaQuery.of(context).size.width * 2) {
        Navigator.pushReplacement(
            context,
            ConcentricPageRoute(
                builder: (ctx) {
                  return LoginPage();
                },
                fullscreenDialog: true));
      }
    });
  }

  List<Map<String, dynamic>> _pantallasBienvenida = [
    {
      'texto': 'Resoluciones FISEI',
      'descripcion': 'Todas tus resoluciones en un solo lugar',
      'imagen': 'assets/images/certificate.png',
      'color': Colors.white
    },
    {
      'texto': 'Historial de tus Resoluciones',
      'descripcion':
          'Mira el listado de todas las resoluciones que te pertenecen',
      'imagen': 'assets/images/push-pin.png',
      'color': Colors.black
    },
    {
      'texto': 'Recibe notificaciones',
      'descripcion':
          'Recibiras notificaciones cuando se te genere una resolución',
      'imagen': 'assets/images/mail.png',
      'color': Colors.white
    }
  ];
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.09;
    return Scaffold(
      body: ConcentricPageView(
        pageController: pc,
        colors: <Color>[
          Color(0XFF8F51A4),
          Color(0XFFF6CE8D),
          Color(0XFF97B8ED)
        ],
        itemCount: 3,
        physics: BouncingScrollPhysics(),
        itemBuilder: (int index, double value) {
          Map<String, dynamic> datos = _pantallasBienvenida[index];
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Image.asset(
                    datos['imagen'],
                  ),
                  width: MediaQuery.of(context).size.width / 1.6,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        datos['texto'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: datos['color'],
                            fontSize: fontSize,
                            fontFamily: 'SF'),
                      ),
                      SizedBox(height: 5),
                      Text(
                        datos['descripcion'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: datos['color'].withOpacity(0.8),
                            fontSize: fontSize * 0.6,
                            fontFamily: 'SF'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: fontSize * 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
