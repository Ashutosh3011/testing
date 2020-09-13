import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_plugin_example/profile_display.dart';

import 'package:geolocator/geolocator.dart';
import './home.dart';
import './opt_verify.dart';
import './settings.dart';
import './Database/location_send.dart';
import 'customtrigger.dart';
import './constants.dart';
import './signin.dart';
import './profile.dart';
import './splashscreen.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    startForegroundService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // return MultiProvider(
    //     providers: [
    //       // ChangeNotifierProvider<StateSetManager>.value(
    //       //   value: StateSetManager(),
    //       // )
    //     ],
    //     child:
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login",
      theme: ThemeData(primaryColor: Colors.orange[200]),
      routes: <String, WidgetBuilder>{
        splashScreen: (BuildContext context) => SplashScreen(),
        signIn: (BuildContext context) => SignInPage(),
        profileScreen: (BuildContext context) => ProfileScreen(),
        otpScreen: (BuildContext context) => OtpScreen(),
        homeScreen: (BuildContext context) => HomeScreen(),
        settingsScreen: (BuildContext context) => SettingsScreen(),
        customTriggerScreen: (BuildContext context) => CustomTriggerPage(),
        profileDisplay: (BuildContext context) => ProfileDisplay(),
      },
      initialRoute: splashScreen,
    );
  }
}

void startForegroundService() async {
  await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 3);
  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      print("Foreground on Started");
    },
    onStopped: () {
      print("Foreground on Stopped");
    },
    title: "Sentinel Service",
    content: "Coming Soon",
    iconName: "icon",
  );
}

Future<void> globalForegroundService() async {
  // final position = await Geolocator()
  //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // String latitude = position.latitude.toString();
  // String longitude = position.longitude.toString();
  // print(position.latitude);
  // print(position.longitude);
  // PostServices.addLocation(mobileNumber, latitude, longitude);
  // debugPrint("current datetime is ${DateTime.now()}");
}
