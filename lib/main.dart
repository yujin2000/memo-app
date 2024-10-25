import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memo_app/home.dart';
import 'package:flutter_memo_app/memo_list_controller.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCTipEovLJqpYLlhRGnV_rOVqrGhZg0P8M',
      appId: '1:633752338389:android:2faf4a76254b4b9f11075c',
      messagingSenderId: '633752338389',
      projectId: 'flutter-memo-app-b3f8e',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialBinding 에 하는 것이 build 에서 하는 거 보다 의존성 주입이 안정성 있음
      initialBinding: BindingsBuilder(() {
        Get.put(MemoListController());
      }),
      home: Home(),
    );
  }
}
