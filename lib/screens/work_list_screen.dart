import 'package:flutter/material.dart';
import 'package:seicheese/compoents/footer.dart';
import 'package:seicheese/compoents/header.dart';


class WorkListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // ヘッダーの高さを100に設定
        child: Header(), // Headerをここに追加
      ),      
      body: const Center(
        child: Text('作品一覧へようこそ！'),
      ),
      bottomNavigationBar: Footer(), // フッターを表示
    );
  }
}
