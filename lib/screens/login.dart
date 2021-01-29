import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisei_administrativo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String numeroCedula = "";
  int paso = 0;
  bool sending = false;
  String codigoVerificacion = "";
  String verificationId;
  final TextEditingController _pinPutController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Color(0XFF781617), width: 1.5),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  void pedirCodigo() async {
    // numeroCedula = "0982339928";

    setState(() {
      this.sending = true;
    });
    var datos;
    try {
      var response =
          await http.get('http://40.74.242.68/api/estudiantes/' + numeroCedula);
      if (response.statusCode != 200) {
        print('ERROR');
        Toast.show('Estudiante no encontrado', context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG,
            backgroundColor: Color(0XFFFF4365));
        setState(() {
          this.sending = false;
        });
        return;
      } else {
        datos = jsonDecode(response.body);
        print(datos);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('info_estudiante', jsonEncode(datos));
      }
    } catch (e) {
      print('ERROR2');
      Toast.show('Upps! Hubo un error', context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Color(0XFFFF4365));
      setState(() {
        this.sending = false;
      });
      return;
    }

    String telefono = datos['telefono'];
    print("+593" + telefono.substring(1));

    await auth.verifyPhoneNumber(
      phoneNumber: "+593" + telefono.substring(1),
      verificationCompleted: (PhoneAuthCredential credential) async {
        //await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Toast.show('Upps! Hubo un error', context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG,
            backgroundColor: Color(0XFFFF4365));
        setState(() {
          this.sending = false;
        });
      },
      codeSent: (String verificationId, int resendToken) {
        this.verificationId = verificationId;
        setState(() {
          this.paso = 1;
          this.sending = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verificarCodigo() async {
    try {
      setState(() {
        sending = true;
      });
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: codigoVerificacion);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        sending = false;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    } catch (e) {
      Toast.show('Upps! Código incorrecto', context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Color(0XFFFF4365));
      setState(() {
        sending = false;
      });
    }
  }

  Widget _buildPin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: Image.asset(
            'assets/images/application.png',
          ),
        ),
        SizedBox(
          height: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                color: Color(0XFF6B6D76).withOpacity(0.2),
                height: 1,
              )
            ],
          ),
        ),
        Text(
          'Ingresar código enviado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        PinPut(
          fieldsCount: 6,
          autofocus: true,
          onChanged: (e) {
            codigoVerificacion = e;
          },
          textStyle: TextStyle(fontSize: 20),
          // onSubmit: (String pin) => _showSnackBar(pin, context),
          //focusNode: _pinPutFocusNode,
          inputDecoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 20), border: InputBorder.none),
          controller: _pinPutController,
          submittedFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(20.0),
          ),
          selectedFieldDecoration: _pinPutDecoration,
          followingFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Color(0XFF781617).withOpacity(.5),
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildButton('VERIFICAR CÓDIGO', verificarCodigo)
      ],
    );
  }

  Widget _buildButton(String texto, Function callback) {
    return RaisedButton(
        color: Color(0XFF781617),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        onPressed: () {
          if (!sending) {
            callback();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          child: Center(
              child: sending
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ))
                  : Text(
                      texto,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
        ));
  }

  Widget _buildCedulaPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: Image.asset(
            'assets/images/student.png',
          ),
        ),
        SizedBox(
          height: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                color: Color(0XFF6B6D76).withOpacity(0.2),
                height: 1,
              )
            ],
          ),
        ),
        Text(
          'Cédula del estudiante',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (e) {
            this.numeroCedula = e;
          },
          maxLength: 10,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
          ),
          autofocus: true,
          decoration: InputDecoration(
              fillColor: Color(0XFF6B6D76).withOpacity(0.2),
              focusedBorder: InputBorder.none,
              filled: true),
        ),
        SizedBox(height: 10),
        _buildButton('INICIAR SESIÓN', pedirCodigo)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0XFF781617),
        title: Text('INICIAR SESIÓN'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedCrossFade(
          firstChild: this.paso == 0 ? _buildCedulaPage() : Container(),
          secondChild: this.paso == 1 ? _buildPin() : Container(),
          crossFadeState: this.paso == 0
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 250),
        ),
      )),
    );
  }
}
