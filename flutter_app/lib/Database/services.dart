import 'package:http/http.dart' as http;
import 'users.dart';

class GetServices {
  static const String url = 'http://142.93.217.138/production/fetch_data.php';
  static Future<List<Users>> getUsers() async {
    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        final List<Users> users = usersFromJson(response.body);
        return users;
      } else {
        return List<Users>();
      }
    } catch (e) {
      return List<Users>();
    }
  }
}

class PostServices {
  static const String url = 'http://142.93.217.138/production/send_data.php';
  static Future<String> addEmployee(
      String mobile,
      String firstName,
      String lastName,
      String emailId,
      String gender,
      String bloodGroup,
      String dob,
      String eCont1,
      String eCont2,
      String eCont3) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = 'ADD_EMP';

      map["mobile"] = mobile;
      map["first_name"] = firstName;
      map["last_name"] = lastName;
      map["email_id"] = emailId;
      map["gender"] = gender;
      map["blood_group"] = bloodGroup;
      map["dob"] = dob;
      map["e_cont1"] = eCont1;
      map["e_cont2"] = eCont2;
      map["e_cont3"] = eCont3;

      final response = await http.post(url, body: map);
      print("addEmployee >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }
}

/////    log in 23/07/2020   check grp msg for more info
// class MobileServices {
//   static const String url = 'http://142.93.217.138/mobilecheck.php';
//   static Future<String> addMobile(String mobileNumber) async {
//     try {
//       var map = new Map<String, dynamic>();

//       // mobileNumber = '12345';
//       map["mobile"] = mobileNumber;

//       // map["last_name"] = lastName;
//       final response = await http.post(url, body: map);
//       print("addMobile >> Response:: ${response.body}");
//       return response.body;
//     } catch (e) {
//       return 'error';
//     }
//   }
// }
/////////////////////////////////////////////////
