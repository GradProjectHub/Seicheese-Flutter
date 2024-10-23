import 'package:flutter/material.dart';
import 'package:seicheese/screens/main_screen.dart';
import 'package:seicheese/screens/other_screen.dart'; // OtherScreenをインポート

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book), // ホーム画面
          label: 'スタンプカード',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map), // 検索画面
          label: 'マップ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tab), // 設定画面
          label: 'メニュー',
        ),
      ],
      onTap: (int index) {
        // 各アイコンが押されたときの処理
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OtherScreen()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OtherScreen()),
          );
        }
      },
    );
  }
}
