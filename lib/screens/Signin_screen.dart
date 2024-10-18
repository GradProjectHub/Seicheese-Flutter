import 'package:flutter/material.dart';
import 'package:seicheese/screens/main_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サインイン'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ボタンが押されたときに MainScreen に遷移
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
          child: const Text('サインイン'),
        ),
      ),
    );
  }
}
