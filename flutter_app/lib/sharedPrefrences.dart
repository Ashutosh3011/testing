import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrences1 {
  SharedPreferences _sharedPreferences;
  int data = 0;

  void initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    data = _sharedPreferences.getInt('value') ?? 0;
    print("Data = $data");
  }
}
