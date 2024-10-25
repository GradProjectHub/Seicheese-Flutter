import 'package:flutter/material.dart'; 
import 'package:seicheese/screens/main_screen.dart';
import 'package:seicheese/screens/menu_screen.dart'; // OtherScreenをインポート
import 'package:seicheese/screens/stamp_screen.dart'; // StampScreenをインポート


class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // フッターの高さを70に設定
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // ホーム画面
            label: 'スタンプカード',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map), // マップ画面
            label: 'マップ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tab), // メニュー画面
            label: 'メニュー',
          ),
        ],
        onTap: (int index) {
          // 各アイコンが押されたときの処理
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StampScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          }
        },
      ),
    );
  }
}
