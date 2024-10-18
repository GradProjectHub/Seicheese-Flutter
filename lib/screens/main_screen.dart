import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メイン画面'),
      ),
      body: const Center(
        child: Text('メイン画面へようこそ！'),
      ),
    );
  }
}
