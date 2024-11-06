import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 150, // ヘッダーの高さを設定
          color: const Color.fromARGB(255, 255, 255, 255), // 背景色
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // 右寄せに設定
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 40), // 上と右に余白を追加
                child: IconButton(
                  icon: const Icon(Icons.search), // 虫眼鏡のアイコン
                  iconSize: 40, // アイコンのサイズ
                  onPressed: () {
                    // アイコンが押されたときの処理
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 173, 173, 173), // 線の色を黒に設定
          thickness: 2, // 線の太さを調整
          height: 1, // 線の高さ
        ),
      ],
    );
  }
}
