import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/utils/routes.dart';

// Future<void> _messageHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  //await _prefs.init();
  //if (!kIsWeb) {
    //await Firebase.initializeApp();
    //FirebaseMessaging.onBackgroundMessage(_messageHandler);
 // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //late FirebaseMessaging firebaseMessaging;

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!kIsWeb) {
    //     firebaseMessaging = FirebaseMessaging.instance;
    //     FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //       String title = event.notification?.title ?? '';
    //       String body = event.notification?.body ?? '';
    //     });
    //     FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //       Get.offAllNamed('/alerts');
    //     });
    //   }
    // });
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.primaryColor,
    ));
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (BuildContext context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "JengApp",
        theme: ThemeData(
          scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.amaranthTextTheme(),
        ),
        initialRoute: "/",
        getPages: Routes.routes,
      ),
    );
  }
}
