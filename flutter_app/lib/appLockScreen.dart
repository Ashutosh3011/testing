import 'dart:async';
import 'dart:io';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passcode Lock Screen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExampleHomePage(title: 'Passcode Lock Screen Example'),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  ExampleHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final LocalAuthentication localAuth = LocalAuthentication();
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  Image myImage;
  bool isAuthenticated = false;
  @override
  void initState() {
    forme();

    myImage = Image.asset('lib/assets/icon.png', height: 75, width: 75);
    super.initState();
  }

  forme() async {
    bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;
    if (weCanCheckBiometrics) {
      bool authenticated = await localAuth.authenticateWithBiometrics(
        localizedReason: "Authenticate to see your bank statement.",
      );
      if (authenticated) {
        print("object");
      }
    } else {
      _showLockScreen(
        context,
        opaque: false,
        cancelButton: Text(
          'Cancel',
          style: const TextStyle(fontSize: 16, color: Colors.white),
          semanticsLabel: 'Cancel',
        ),
      );
    } //fin
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(myImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // RaisedButton(
            //   onPressed: () {
            //     var i = 0;
            //     while (i <= 10) {
            //       TorchCompat.turnOn();
            //       sleep(Duration(seconds: 1));
            //       TorchCompat.turnOff();
            //       sleep(Duration(seconds: 1));
            //       // Flashlight.lightOn();
            //       i++;
            //     }
            //   },
            // ),
            Text('You are ${isAuthenticated ? '' : 'NOT'} authenticated'),
            // _defaultLockScreenButton(context),
            RaisedButton(onPressed: () async {
              bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

              if (weCanCheckBiometrics) {
                bool authenticated = await localAuth.authenticateWithBiometrics(
                  localizedReason: "Authenticate to see your bank statement.",
                );
                if (authenticated) {
                  print("object");
                }
              } else {
                _showLockScreen(
                  context,
                  opaque: false,
                  cancelButton: Text(
                    'Cancel',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    semanticsLabel: 'Cancel',
                  ),
                );
              } //fingerprint if
            })
          ],
        ),
      ),
    );
  }

  _showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig,
      Widget cancelButton,
      List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            image: myImage,
            // image: Image.asset(
            //   myImage,
            //   height: 75,
            //   width: 75,
            //   // fit: BoxFit.fitWidth,
            // ),
            // image: Image.asset("icon.png"),
            title: Text(
              'Enter App Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '123456' == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
