

import 'package:calamansi_recognition/pages/login/views.dart';
import 'package:calamansi_recognition/pages/recognition/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter',
      theme: ThemeData(
      ),
      getPages: [
        GetPage(name: "/login", page:()=>Login()),
        GetPage(name: "/dashboard", page:()=>AddPantry()),
      ],
      initialRoute: "/login",
    );
  }
}
