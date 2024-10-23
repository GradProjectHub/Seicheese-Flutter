import 'package:flutter/material.dart';
import 'package:seicheese/screens/main_screen.dart';
import 'package:seicheese/screens/other_screen.dart'; // OtherScreenをインポート

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // ホーム画面
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search), // 検索画面
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings), // 設定画面
          label: 'Settings',
        ),
      ],
      onTap: (int index) {
        // 各アイコンが押されたときの処理
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OtherScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        }
      },
    );
  }
}
