import 'package:flutter/material.dart';
import 'package:seicheese/screens/other_screen.dart';
import 'package:seicheese/screens/signin_screen.dart'; // SignInScreenをインポート

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(), // サインイン画面を最初の画面に設定
    );
  }
}
