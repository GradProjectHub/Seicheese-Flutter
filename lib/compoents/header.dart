import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // ヘッダーの高さを100に設定
      color: const Color.fromARGB(255, 255, 255, 255), // 背景色
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // 右寄せに設定
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10,top: 40), // 上と右に余白を追加して配置を調整
            child: IconButton(
              icon: const Icon(Icons.search), // 虫眼鏡のアイコン
              iconSize: 40, // アイコンのサイズ
              onPressed: () {
                // アイコンが押されたときの処理をここに追加
              },
            ),
          ),
        ],
      ),
    );
  }
}
