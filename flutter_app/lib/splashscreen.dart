import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  SharedPreferences _sharedPreferences;
  int data = 0;
  bool verified = false;
  AnimationController animationController;
  Animation<double> animation;
  Image iconImage;
  Image logoImage;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (data == null) {
      Navigator.of(context).pushReplacementNamed(signIn);
    } else {
      forme();
    }
  }

  final LocalAuthentication localAuth = LocalAuthentication();
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  Image myImage;
  bool isAuthenticated = false;
  @override
  void initState() {
    myImage = Image.asset('lib/assets/icon.png', height: 75, width: 75);
    initializeSharedPref();
    super.initState();
    logoImage = Image.asset('lib/assets/iwlogo1.png', height: 50, width: 60);
    iconImage = Image.asset(
      'lib/assets/logo.png',
    ); // height: 75, width: 75);
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 0));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  forme() async {
    int wrongPass = 0;
    bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;
    if (weCanCheckBiometrics) {
      bool authenticated = await localAuth.authenticateWithBiometrics(
        localizedReason: "Authenticate to see your bank statement.",
      );
      if (authenticated) {
        verified = true;
        Navigator.of(context).pushReplacementNamed(homeScreen);
        print("object");
      } else if (authenticated == false && wrongPass < 3) {
        wrongPass++;
      } else if (wrongPass >= 3) {
        _showLockScreen(
          context,
          opaque: false,
          cancelButton: Text(
            'Cancel',
            style: const TextStyle(fontSize: 16, color: Colors.white),
            semanticsLabel: 'Cancel',
          ),
        );
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

    precacheImage(logoImage.image, context);
    precacheImage(iconImage.image, context);
  }

  void initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    data = _sharedPreferences.getInt("value");
    print(" IN SPLASHHSCREENNN   $data");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ImageProvider logo = AssetImage("lib/assets/iwlogo1.png");

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Transform.scale(
                    scale: 0.7,
                    child: iconImage,
                  ))
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(50, 50, 140, 45),
                child: Text(
                  "Powered by",
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.black,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: logoImage,
                // child: Image(
                //   height: 50,
                //   width: 60,
                //   // image: AssetImage('lib/assets/icon.png'),
                //   image: logoImage,
                // ),
              )
            ],
          ),
        ],
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
            // image: myImage,
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
