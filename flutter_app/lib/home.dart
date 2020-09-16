import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:torch_compat/torch_compat.dart';
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
                        Navigator.of(context).pushNamed(lockScreen);
                      },
                    ),
                    RaisedButton(
                        child: Text("Get Location"),
                        onPressed: () {
                          _getCurrentLocation();
                          tcount = 0;
                          fcount = 0;
                          sosflash();

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
      sosflash();
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

    // playLoopedMusic();
    // AudioCache musicCache;
    // AudioPlayer instance;

    print("loop");

    // musicCache = AudioCache(prefix: "lib/assets/");
    // instance = await musicCache.loop("audio.mp3");
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => Flashlight.lightOn());
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => sosshort());
// TorchCompat.turnOn();
// TorchCompat.turnOff();
    Timer.periodic(const Duration(seconds: 1), (timer1) {
      if (tcount >= 9) {
        timer1.cancel();
      }
      // Flashlight.lightOn();
      // TorchCompat.turnOn();
      tcount++;
      print(tcount);
    });
    Timer.periodic(const Duration(seconds: 2), (timer2) {
      if (fcount >= 10) {
        timer2.cancel();
      }
      // Flashlight.lightOff();
      // TorchCompat.turnOff();
      fcount++;
      print(fcount);
    });

    // sosshort();
    // soslong();
    // sosshort();
  }

  sosshort() {
    // int i = 0;
    // while (i <= 2) {
    //   Flashlight.lightOn();
    //   sleep(Duration(milliseconds: 500));
    //   Flashlight.lightOff();
    //   sleep(Duration(milliseconds: 500));
    //   i++;
    // }
  }

  soslong() {
    int i = 0;
    while (i <= 2) {
      Flashlight.lightOn();
      sleep(Duration(milliseconds: 1500));
      Flashlight.lightOff();
      sleep(Duration(milliseconds: 1500));

      i++;
    }
  }

  // void playLoopedMusic() async {
  //   AudioCache musicCache;
  //   // AudioPlayer instance;
  //   print("loop");

  //   musicCache = AudioCache(prefix: "lib/assets/");
  //   instance = await musicCache.loop("audio.mp3");
  //   // await instance.setVolume(0.5); you can even set the volume
  // }

  void pauseMusic() {
    if (instance != null) {
      instance.pause();
    }
  }
}
