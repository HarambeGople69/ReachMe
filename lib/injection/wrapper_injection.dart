

import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUploadInjection {
  
  registerInjection() {
    final box = GetStorage();
    box.write("state", 1);
    print(
        box.read("state").toString() + " is from widget injection registered");
        
  }

  loginInjection() {
    final box = GetStorage();
    box.write("state", 0);
    print(box.read("state").toString() + " is from widget injection loggedin");
  }

  logoutInjection() {
    final box = GetStorage();
    box.remove("state");
    print(
        box.read("state").toString() + " is from widget injection logged out");
  }
}
