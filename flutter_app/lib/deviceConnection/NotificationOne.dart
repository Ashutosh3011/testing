import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

class OneSignalAPI {
  static configOneSignal() async {
    // Future Getdata(url) async {
    //   // url = "http://142.93.217.138/onesignal.py";
    //   http.Response Response = await http.get(url);
    //   return Response.body;
    // }

    print("One signal configuration");

    await OneSignal.shared.promptLocationPermission();
    await OneSignal.shared.setLocationShared(true);
    // await OneSignal.shared.init("f7cc6466-ed27-4485-ae78-fd6a4b1daac4");

    await OneSignal.shared.init("82c063b9-b6e5-44d7-8826-976cf7cb27aa");

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler((notification) {
      // setState(() {
      //   notifyContent =
      //       notification.jsonRepresentation().replaceAll('\\n', '\n');
      // });
    });
  }
}
