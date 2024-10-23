import 'package:flutter/material.dart';
import 'package:seicheese/compoents/footer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showCancel = false;

  // 登録ボタンの切り替え
  void toggleButton() {
    setState(() {
      showCancel = !showCancel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F2F8),
      body: Column(
        children: [
          // ヘッダーの白いボックス
          Container(
            height: 100,
            color: Colors.white,
          ),
          Expanded(
            child: Stack(
              children: [
                // 登録ボタン（左下）
                Positioned(
                  bottom: 0, // ボタンを画面の下部に配置
                  left: 20,
                  child: ElevatedButton(
                    onPressed: toggleButton,
                    child: Text(
                      showCancel ? 'キャンセル' : '登録',
                      style: TextStyle(
                        fontSize: 20, // 文字を大きく
                        color: Colors.white, // 文字色を白に設定
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0077E6), // 登録ボタンの色
                      minimumSize: Size(95, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 角を少し丸く
                      ),
                      elevation: 5, // 影を付けて見やすく
                    ),
                  ),
                ),
                // チェックインボタン（右下）
                Positioned(
                  bottom: 0, // ボタンを画面の下部に配置
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      // サブスクリーンへの遷移処理を実装
                    },
                    child: Text(
                      'チェックイン',
                      style: TextStyle(
                        fontSize: 20, // 文字を大きく
                        color: Colors.white, // 文字色を白に設定
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF005DB4), // チェックインボタンの色
                      minimumSize: Size(120, 90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      elevation: 5, // 影を付けて見やすく
                    ),
                  ),
                ),
              ],
            ),
          ),
          // フッターの白いボックス
          Container(
            height: 100,
            color: Colors.white,
          ),
        ],
      ),
      bottomNavigationBar: Footer(), // フッターを表示
    );
  }
}
