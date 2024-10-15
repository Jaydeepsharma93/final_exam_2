import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_2/view/homepage.dart';
import 'package:final_exam_2/view/loginpage.dart';
import 'package:final_exam_2/view/splashpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'controller/authcontroller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/", page: () => SplashPage()),
        GetPage(name: "/home", page:() => Obx(() =>(authController.user.value != null) ? HomePage() : LoginPage()),),
        GetPage(name: "/login", page: () => LoginPage(),)
      ],
    );
  }
}
