import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import './Database/location_send.dart';
import './localdata.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'constants.dart';
import './deviceConnection/NotificationOne.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashlight/flashlight.dart';

GoogleMapController mapController;
CameraPosition _initialLocation =
    CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 3.474);

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> triggerVerify = List();
  Timer timer;
  String _locationMessage = "";

  SharedPreferences _sharedPreferences;

  final Geolocator position = Geolocator();

  Color color;
  int volumeUpCount = 0;
  int i = 1;
  int j = 0;
  int volumeDownCount = 0;
  int homeButtonCount = 0;
  int lockButtonCount = 0;

  String _latestHardwareButtonEvent;

  String fname = "";
  String fname1 = "";
  String lname = "";
  String fileContents = "";
  String imageString = "";
  Image imageFromPreferences;
  bool triggerSwitch;
  List<int> triggerSaved = List();
  bool _hasFlashlight = false;
  bool stopped = false;
  AudioPlayer instance;
  AudioCache musicCache;
  int fcount = 0, tcount = 0;

  StreamSubscription<HardwareButtons.VolumeButtonEvent>
      _volumeButtonSubscription;
  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;
  StreamSubscription<HardwareButtons.LockButtonEvent> _lockButtonSubscription;
  @override
  void initState() {
    LocationSender();
    // _getCurrentLocation();
    // testing();
    // color = Colors.red;
    readFromFile();
    OneSignalAPI.configOneSignal();
    super.initState();
    initializeSharedPref();
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => triggerVerify.clear());
    _volumeButtonSubscription =
        HardwareButtons.volumeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = event.toString();
        // volumeCount = 1;
        if (_latestHardwareButtonEvent == "VolumeButtonEvent.VOLUME_UP") {
          volumeUpCount = 1;

          lockButtonCount = 0;
          homeButtonCount = 0;
          volumeDownCount = 0;
        } else {
          volumeDownCount = 1;
          j = 1;
          volumeUpCount = 0;
          lockButtonCount = 0;
          homeButtonCount = 0;
        }
      });
    });

    _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = 'HOME_BUTTON';
        volumeDownCount = 0;
        volumeUpCount = 0;
        lockButtonCount = 0;
        homeButtonCount = 1;
        i = j = 0;
      });
    });

    _lockButtonSubscription = HardwareButtons.lockButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = 'LOCK_BUTTON';
        volumeDownCount = 0;
        volumeUpCount = 0;
        lockButtonCount = 1;
        homeButtonCount = 0;
      });
    });
  }

  void readFromFile() async {
    await LocalData.readFromFile().then((contents) {
      setState(() {
        fileContents = contents;
      });
    });

    try {
      List<String> fileContentsList = fileContents.split(',');

      triggerSaved = fileContentsList
          .map((fileContents) => int.parse(fileContents))
          .toList();
      // print(triggerSaved.runtimeType);/to check the type of variable
    } on Exception catch (_) {
      print("testing");
    }
  }

  void initializeSharedPref() async {
    initFlashlight();
    _sharedPreferences = await SharedPreferences.getInstance();
    fname = _sharedPreferences.getString('fname') ?? null;
    lname = _sharedPreferences.getString('lname') ?? null;
    triggerSwitch = _sharedPreferences.getBool('triggerSwitch') ?? null;
    imageString = _sharedPreferences.getString('image') ?? null;
    imageFromPreferences = Image.memory(base64Decode(imageString));
    print("Data = $fname $triggerSwitch");
    print("Data = $fname");
    setState(() {});
  }

  Future SendNotification(url) async {
    http.Response Response = await http.get(url);
    return Response.body;
  }

  initFlashlight() async {
    bool hasFlash = await Flashlight.hasFlashlight;
    print("Device has flash ? $hasFlash");
    setState(() {
      _hasFlashlight = hasFlash;
    });
  }

  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage = "${position.latitude},${position.longitude}";
      print(_locationMessage);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    _volumeButtonSubscription?.cancel();
    _homeButtonSubscription?.cancel();
    _lockButtonSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text("HOME"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.orange[200], Colors.pinkAccent])),
            ),
          ),
          drawer: Drawer(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.orange[200], Colors.pinkAccent])),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 64, 10, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        profilePicture(),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            fname + " " + lname,
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    ListTile(
                        title: new Text("Settings"),
                        onTap: () {
                          Navigator.of(context).pushNamed(settingsScreen);
                        }),
                    new ListTile(
                        title: new Text("Profile"),
                        onTap: () {
                          Navigator.of(context).pushNamed(profileDisplay);
                        }),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Press The Hardware Buttons to Start $triggerSaved",
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 20),
                    triggerSwitch == true
                        ? triggernew()
                        : Text("Please turn ON the triggers from setting"),
                    SizedBox(height: 50),
                    // mapAshh(),
                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(border: Border.all()),
                      child: GoogleMap(
                        // markers: markers != null ? Set<Marker>.from(markers) : null,
                        initialCameraPosition: _initialLocation,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                      ),
                    ),
                    RaisedButton(
                        child: Text("Directions"),
                        onPressed: () {
                          MapsLauncher.launchCoordinates(
                              19.0423287, 72.9329511);
                        }),
                    SizedBox(height: 50),
                    RaisedButton(
                      child: Text("New Screen"),
                      onPressed: () {
                        stopped = true;
                        print(stopped);
                        flashlight();
                        // Navigator.of(context).pushNamed(lockScreen);
                      },
                    ),
                    RaisedButton(
                        child: Text("Get Location"),
                        onPressed: () {
                          stopped = false;
                          print(stopped);
                          flashlight();

                          // _getCurrentLocation();//enable this

                          // OneSignalAPI.configOneSignal();
                          // SendNotification("http://142.93.217.138/development/execution.php");
                        }),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget mapAshh() {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(border: Border.all()),
      child: GoogleMap(
        // markers: markers != null ? Set<Marker>.from(markers) : null,
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }

  Widget profilePicture() {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        child: CircleAvatar(
          child: ClipOval(
            child: Center(
                child: imageFromPreferences == null
                    ? Icon(
                        Icons.add_a_photo,
                        color: Colors.orange[200],
                        size: 20,
                      )
                    : CircleAvatar(
                        radius: 30.0,
                        child: imageFromPreferences,
                        // backgroundImage: imageFromPreferences,
                        backgroundColor: Colors.transparent,
                      )

                // Image.file(
                //     image,
                //     fit: BoxFit.cover,
                //     width: MediaQuery.of(context).size.width,
                //   ),
                ),
          ),
          radius: 30,
          backgroundColor: Colors.white,
        ),
        onTap: () {
          // getImage();
        },
      ),
    );
  }

  Future<bool> backPressed() {
    return showDialog(
        context: context,
        builder: (context) => new CupertinoAlertDialog(
              title: Text(
                "Warning!!",
                style: TextStyle(fontSize: 18),
              ),
              content: Text(
                "Triggers won't work if you close the app",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ));
  }

  Widget triggernew() {
    pauseMusic();

    if (volumeUpCount == 1) {
      triggerVerify.add(1);
    } else if (volumeDownCount == 1) {
      triggerVerify.add(2);
    } else if (homeButtonCount == 1) {
      triggerVerify.add(3);
    } else if (lockButtonCount == 1) {
      triggerVerify.add(4);
    } else if (_latestHardwareButtonEvent == null) {
      print("Verify is $triggerVerify");
    }

    print(triggerVerify);

    if (listEquals(triggerSaved, triggerVerify)) {
      print("triggersequence =" + triggerSaved.toString());
      triggerVerify.clear();
      Text(_hasFlashlight
          ? 'Your phone has a Flashlight.'
          : 'Your phone has no Flashlight.');
      tcount = 0;
      fcount = 0;
      sosflash();
      stopped = false;
      // print(
      //     "*******************************************************************************************************$stopped");

      flashlight();
      tcount++;

      // pauseMusic();

      return Container(
        color: color,
        height: 300,
        width: 300,
        decoration: BoxDecoration(color: Colors.red),
        child: Center(
          child: Text(
            "Triggered",
            style: TextStyle(fontSize: 26),
          ),
        ),
      );
    } else {
      // stopped = true;
      // flashlight();
      print("Trigger didn't match");

      return Container(
        color: color,
        height: 300,
        width: 300,
        child: Center(
          child: Text(
            "Trigger not pressed yet$triggerSaved",
            style: TextStyle(fontSize: 26),
          ),
        ),
      );
    }
  }

  sosflash() async {
    print("flashlight is working");
    print("loop");

    musicCache = AudioCache(prefix: "lib/assets/");
    instance = await musicCache.loop("audio.mp3"); //audio
    // flashlight();
  }

  void flashlight() {
    // Timer.periodic(
    //   const Duration(seconds: 2),
    //   (timer) {
    //     if (tcount <= 4) {
    //       tcount++;
    //       Flashlight.lightOn();

    //       Flashlight.lightOff();
    //       print(
    //           "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^$tcount");
    //       if (tcount > 5) {
    //         timer.cancel();
    //       }
    //     }
    //   },
    // );
    // while (!stopped) {
    Future.delayed(Duration(milliseconds: 500), () {
      Flashlight.lightOn();
      Future.delayed(Duration(milliseconds: 500), () {
        Flashlight.lightOff();
        Future.delayed(Duration(milliseconds: 500), () {
          Flashlight.lightOn();
          Future.delayed(Duration(milliseconds: 500), () {
            Flashlight.lightOff();
            Future.delayed(Duration(milliseconds: 500), () {
              Flashlight.lightOn();
              Future.delayed(Duration(milliseconds: 500), () {
                Flashlight.lightOff();
                Future.delayed(Duration(milliseconds: 1000), () {
                  Flashlight.lightOn();
                  Future.delayed(Duration(milliseconds: 1000), () {
                    Flashlight.lightOff();
                    Future.delayed(Duration(milliseconds: 1000), () {
                      Flashlight.lightOn();
                      Future.delayed(Duration(milliseconds: 1000), () {
                        Flashlight.lightOff();
                        Future.delayed(Duration(milliseconds: 1000), () {
                          Flashlight.lightOn();
                          Future.delayed(Duration(milliseconds: 500), () {
                            Flashlight.lightOff();
                            Future.delayed(Duration(milliseconds: 500), () {
                              Flashlight.lightOn();
                              Future.delayed(Duration(milliseconds: 500), () {
                                Flashlight.lightOff();
                                Future.delayed(Duration(milliseconds: 500), () {
                                  Flashlight.lightOn();
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    Flashlight.lightOff();
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      Flashlight.lightOn();
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        Flashlight.lightOff();
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
    // }
    // Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer1) {
    //     if (fcount < 3) {
    //       tcount++;
    //       Flashlight.lightOn();
    //       Flashlight.lightOff();
    //       print(
    //           "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^$tcount");
    //       if (fcount > 4) {
    //         timer1.cancel();
    //       }
    //     }
    //   },
    // );
  }

  void pauseMusic() {
    if (instance != null) {
      instance.pause();
    }
  }
}
