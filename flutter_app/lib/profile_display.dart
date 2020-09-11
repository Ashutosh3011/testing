import 'dart:convert';
import 'dart:io';
// import 'package:flutter_foreground_plugin_example/onesignal.dart';
import 'package:flutter/material.dart';
import './constants.dart';

import './widgets/customappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Database/services.dart';
import 'Database/users.dart';
import './widgets/custom_shape.dart';
import './widgets/responsive_ui.dart';

class ProfileDisplay extends StatefulWidget {
  ProfileDisplay() : super();
  @override
  _ProfileDisplayState createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  List<Users> _users;
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;
  // ignore: unused_field
  bool _loading;
  SharedPreferences _sharedPreferences;
  int data = 0;

  String mobileNumber = "";
  String fname = "";
  String lname = "";
  String email = "";
  String gender = "";
  String blood = "";
  String dob = "";
  String econt1 = "";
  String econt2 = "";
  String econt3 = "";
  String imageString = " ";
  Image imageFromPreferences;

  @override
  void initState() {
    super.initState();
    initializeSharedPref();
    _loading = true;
    GetServices.getUsers().then((users) {
      setState(() {
        _users = users;
        _loading = false;
      });
    });

    print(_users);
  }

  void initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    mobileNumber = _sharedPreferences.getString('mobile') ?? null;
    fname = _sharedPreferences.getString('fname') ?? null;
    lname = _sharedPreferences.getString('lname') ?? null;
    email = _sharedPreferences.getString('email') ?? null;
    gender = _sharedPreferences.getString('gender') ?? null;
    blood = _sharedPreferences.getString('blood') ?? null;
    dob = _sharedPreferences.getString('dob') ?? null;
    econt1 = _sharedPreferences.getString('econt1') ?? null;
    econt2 = _sharedPreferences.getString('econt2') ?? null;
    econt3 = _sharedPreferences.getString('econt3') ?? null;
    imageString = _sharedPreferences.getString('image') ?? null;
    imageFromPreferences = Image.memory(
      base64Decode(imageString),
    );
    // data = _sharedPreferences.getInt('value') ?? 0;
    print("Data = $data");
  }
//   void configOneSignal() async {
//     await OneSignal.shared.promptLocationPermission();
//     await OneSignal.shared.setLocationShared(true);
//     // await OneSignal.shared.init("f7cc6466-ed27-4485-ae78-fd6a4b1daac4");

//     await OneSignal.shared.init("d4aeac4a-f6b4-494b-8e82-e78ceac1dc2f");

//     OneSignal.shared
//         .setInFocusDisplayType(OSNotificationDisplayType.notification);
//     OneSignal.shared.setNotificationReceivedHandler((notification) {
//       setState(() {
//         notifyContent =
//             notification.jsonRepresentation().replaceAll('\\n', '\n');
//       });
//     });
//   }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        margin: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Opacity(opacity: 0.88, child: CustomAppBar2()),
              clipShape(),
              SizedBox(
                height: 25,
              ),
              heading(),
              detail(),
              buttons(),
              SizedBox(
                height: _height / 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget heading() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Personal Information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _height / 35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detail() {
    return Container(
      // margin: EdgeInsets.all(40),
      margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            fname + " " + lname,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Email",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Gender",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            gender,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Blood Group",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            blood,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Date Of Birth",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            dob,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Emergency Contact 1",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            econt1,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Emergency Contact 2",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            econt2,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Emergency Contact 3",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500),
          ),
          Text(
            econt3,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget buttons() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: _width / 8,
          ),
          RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              Navigator.of(context).pushNamed(profileScreen);
            },
            textColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Container(
              alignment: Alignment.center,
              width:
                  large ? _width / 4 : (medium ? _width / 3.75 : _width / 3.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                  colors: <Color>[Colors.orange[200], Colors.pinkAccent],
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Edit',
                style: TextStyle(fontSize: large ? 14 : (medium ? 12 : 10)),
              ),
            ),
          ),
          SizedBox(
            width: _width / 4.5,
          ),
          RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              data = 0;
              _sharedPreferences.setInt('value', data);
              // print(data);
              Navigator.of(context).pushNamed(homeScreen);
            },
            textColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Container(
              alignment: Alignment.center,
              width:
                  large ? _width / 4 : (medium ? _width / 3.75 : _width / 3.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                  colors: <Color>[Colors.orange[200], Colors.pinkAccent],
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Save',
                style: TextStyle(fontSize: large ? 14 : (medium ? 12 : 10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height:
                  large ? _height / 8 : (medium ? _height / 9 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[100], Colors.pink],
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
              height:
                  large ? _height / 12 : (medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[100], Colors.pink],
                ),
              ),
            ),
          ),
        ),
        profilePicture(),
      ],
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
                      )
                    :
                    // : CircleAvatar(
                    //     radius: 250.0,

                    //     child: imageFromPreferences,
                    //     // backgroundImage: imageFromPreferences,
                    //     backgroundColor: Colors.transparent,
                    //   )
                    imageFromPreferences
                // :

                ),
          ),
          radius: 75,
          backgroundColor: Colors.white,
        ),
        onTap: () {
          // loadImageFromPreferences();
        },
      ),
    );
  }
}
