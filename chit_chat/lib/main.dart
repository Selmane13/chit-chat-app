import 'package:chit_chat/routes/route_helper.dart';
import 'package:chit_chat/views/conversation.dart';
import 'package:chit_chat/views/home_page.dart';
import 'package:chit_chat/views/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:chit_chat/dependencies/dependencies.dart' as dep;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //home: SignInPage(),
      initialRoute: RouteHelper.getSignInPage(),
      getPages: RouteHelper.getPages,
    );
  }
}
