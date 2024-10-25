import 'package:flutter/material.dart';
import 'package:seicheese/compoents/footer.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メニュー'),
      ),
      body: const Center(
        child: Text('メニューへようこそ！'),
      ),
      bottomNavigationBar: Footer(), // フッターを表示
    );
  }
}
