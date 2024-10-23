import 'package:flutter/material.dart';
import 'package:seicheese/compoents/footer.dart';

class OtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('テスト画面'),
      ),
      body: const Center(
        child: Text('テスト画面へようこそ！'),
      ),
      bottomNavigationBar: Footer(), // フッターを表示
    );
  }
}
