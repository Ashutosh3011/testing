// class Secrets {
//   // Add your Google Maps API Key here
//   static const API_KEY = 'AIzaSyCzHTscycMCnVnfZ7aXd7lKOsztq_58TsI';
// }
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _sharedPreferences;
String mobileNumber;

class LocationSender {
  Timer timer =
      Timer.periodic(Duration(seconds: 5), (Timer t) => _getCurrentLocation());
  //add location reciving code
  //and store in database  for storing use a diffrent php code in which pass mobile number to check the user and location

  static _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();
    _sharedPreferences = await SharedPreferences.getInstance();
    mobileNumber = _sharedPreferences.getString('mobile') ?? null;
    print(position.latitude);
    print(position.longitude);
    // PostServices.addLocation(mobileNumber, latitude, longitude);
  }
}

class PostServices {
  static const String url = 'http://142.93.217.138/production/location.php';
  static Future<String> addLocation(
      String mobileNumber, String latitude, String longitude) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = 'LOC';

      map["mobile"] = mobileNumber;
      map["latitude"] = latitude;
      map["longitude"] = longitude;

      final response = await http.post(url, body: map);
      print("addEmployee >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }
}
