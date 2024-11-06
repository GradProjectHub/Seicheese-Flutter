import 'package:flutter/material.dart';
import 'package:seicheese/screens/main_screen.dart';
import 'package:seicheese/screens/menu_screen.dart';
import 'package:seicheese/screens/stamp_screen.dart';

class Footer extends StatelessWidget {
  final int currentIndex; // 現在のインデックスを受け取る

  const Footer({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // フッターの高さを100に設定
      child: BottomNavigationBar(
        currentIndex: currentIndex, // 現在のインデックスを設定
        selectedItemColor: Colors.blue, // 選択されたアイテムの色
        unselectedItemColor: Colors.grey, // 選択されていないアイテムの色
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'スタンプカード',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'マップ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tab),
            label: 'メニュー',
          ),
        ],
        onTap: (int index) {
          // 各アイコンが押されたときの処理
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StampScreen()),
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
