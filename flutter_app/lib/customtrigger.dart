import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import './widgets/custom_shape.dart';
import './widgets/responsive_ui.dart';
import 'localdata.dart';
import 'home.dart';

class CustomTriggerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomTriggerScreen(),
    );
  }
}

class CustomTriggerScreen extends StatefulWidget {
  @override
  _CustomTriggerScreenState createState() => _CustomTriggerScreenState();
}

class _CustomTriggerScreenState extends State<CustomTriggerScreen> {
  int volumeUpCount = 0;
  List<int> triggerSequence = List();
  int i = 0;
  int j = 0;
  String newString = "";
  String newString1 = "";
  String newString2 = "";
  String forprint;
  int volumeDownCount = 0;
  int homeButtonCount = 0;
  int lockButtonCount = 0;
  String _latestHardwareButtonEvent;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  int dropdown;
  SharedPreferences _sharedPreferences;
  StreamSubscription<HardwareButtons.VolumeButtonEvent>
      _volumeButtonSubscription;
  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;
  StreamSubscription<HardwareButtons.LockButtonEvent> _lockButtonSubscription;
  @override
  void initState() {
    super.initState();
    _volumeButtonSubscription =
        HardwareButtons.volumeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = event.toString();
        if (_latestHardwareButtonEvent == "VolumeButtonEvent.VOLUME_UP") {
          _latestHardwareButtonEvent = "VOLUME UP BUTTON";
        } else {
          _latestHardwareButtonEvent = "VOLUME DOWN BUTTON";
        }
      });
    });

    _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = 'HOME BUTTON';
      });
    });

    _lockButtonSubscription = HardwareButtons.lockButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = 'LOCK BUTTON';
      });
    });

    initializeSharedPref();
  }

  void initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    dropdown = _sharedPreferences.getInt('dropdown') ?? null;

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _volumeButtonSubscription?.cancel();
    _homeButtonSubscription?.cancel();
    _lockButtonSubscription?.cancel();
  }

  void printer() {
    setState(() {
      print(j);
      if (j == 1) {
        newString = forprint;
      } else if (j == 2) {
        newString1 = forprint;
      } else if (j == 3) {
        newString2 = forprint;
      } else if (j == 0) {
        newString = "";
        newString1 = "";
        newString2 = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: _width,
            height: _height,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    clipShape(),
                    pagetitle(),
                    methodDescription(),
                    SizedBox(height: 25),
                    Text(
                      'Button Pressed: $_latestHardwareButtonEvent\n',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text("$newString"),
                    Text("$newString1"),
                    Text("$newString2"),
                  ],
                ),
                Positioned(
                  bottom: 49,
                  child: Row(children: [
                    Container(
                      height: _height / 13,
                      width: _width / 2,
                      child: RaisedButton(
                          elevation: 10,
                          color: Colors.orange[400],
                          child: Text("Record"),
                          onPressed: () {
                            print("RECORDING button");
                            readTrigger();
                            printer();
                            print("j = $j");
                          }),
                    ),
                    Container(
                      height: _height / 13,
                      width: _width / 2,
                      child: RaisedButton(
                          elevation: 10,
                          color: Colors.orange[400],
                          child: Text("Retry"),
                          onPressed: () {
                            j = 0;
                            triggerSequence.clear();
                            print(triggerSequence);
                            printer();
                            _latestHardwareButtonEvent = null;
                            i = 0;
                            print("Retrying");
                          }),
                    ),
                  ]),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: _height / 13,
                    width: _width,
                    child: RaisedButton(
                        color: Colors.orange[400],
                        child: Text("Submit"),
                        onPressed: () {
                          if (triggerSequence.length == 3) {
                            
                            dropdown = 1;
                            _sharedPreferences.setInt('dropdown', dropdown);

                            String fileContents = triggerSequence.toString();
                          
                            fileContents = fileContents.replaceAll('[', '');
                            fileContents = fileContents.replaceAll(']', '');
                 
                            LocalData.saveToFile(fileContents);

                           

                            print("Route to home Screen");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          } else if (triggerSequence.length < 3) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      "Please retry!!",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    content: Text(
                                      "Pattern less than 3",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height:
                  _large ? _height / 2 : (_large ? _height / 9 : _height / 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[800], Colors.orange[600]],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 9.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[400], Colors.red],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget pagetitle() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20),
      child: Row(
        children: <Widget>[
          Text(
            "Steps",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget methodDescription() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20),
      child: Column(
        children: [
          Text("""1.Press the Hardware button and click record
2. Repeat step 1 for 3 times only
3.Press Retry to startover""",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
        ],
      ),
    );
  }

  void readTrigger() {
    if (j < 3) {
      if (_latestHardwareButtonEvent == "VOLUME UP BUTTON") {
        triggerSequence.add(1);
        forprint = _latestHardwareButtonEvent;
        _latestHardwareButtonEvent = null;
        i++;
        j++;
      } else if (_latestHardwareButtonEvent == "VOLUME DOWN BUTTON") {
        triggerSequence.add(2);
        forprint = _latestHardwareButtonEvent;
        _latestHardwareButtonEvent = null;
        j++;
        i++;
      } else if (_latestHardwareButtonEvent == "HOME BUTTON") {
        triggerSequence.add(3);
        forprint = _latestHardwareButtonEvent;
        _latestHardwareButtonEvent = null;
        j++;
        i++;
      } else if (_latestHardwareButtonEvent == "LOCK BUTTON") {
        triggerSequence.add(4);
        forprint = _latestHardwareButtonEvent;
        _latestHardwareButtonEvent = null;
        j++;
        i++;
      }
      print(triggerSequence);
    } else {
      print("Limit exceeded");
      print(triggerSequence);
    }
  }
}
