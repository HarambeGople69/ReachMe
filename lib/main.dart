import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/splash_page.dart';

// SHA1 6b:4e:8d:a6:4b:70:f9:48:60:6e:a1:5a:83:01:9c:38:db:2f:2b:98
//SHA 256 91:ac:ce:09:13:30:86:28:ad:d0:72:ba:b5:27:18:4b:31:ba:b7:57:32:4e:41:d3:8e:ec:51:28:7f:da:d2:64

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(
    const MyApp(),
  );
}

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    // ignore: prefer_const_constructors
    return ScreenUtilInit(
      builder: () => GetMaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
        ),
        debugShowCheckedModeBanner: false,
        // ignore: prefer_const_constructors
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/screen4': (BuildContext context) => HomePage()
        },
      ),
    );
  }
}
