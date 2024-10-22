import 'package:flutter/material.dart';
import 'package:seicheese/screens/main_screen.dart'; // MainScreenをインポート

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF070), // 背景色を指定
      body: Center(
        child: Container(
          // 白い枠のコンテナ
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white, // 白い背景
            borderRadius: BorderRadius.circular(20), // 角を丸くする
          ),
          width: MediaQuery.of(context).size.width * 0.8, // 幅を調整
          child: Column(
            mainAxisSize: MainAxisSize.min, // コンテンツに応じた高さ
            children: [
              // ロゴ部分
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/icons/logo.jpg', // ロゴ画像を表示
                  height: 100,
                ),
              ),
              // Googleサインインボタン
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                icon: Image.asset(
                  'assets/icons/google-icon.png', // Googleアイコン
                  height: 24,
                ),
                label: const Text('Sign In with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // ボタンの背景色
                  foregroundColor: Colors.black, // ボタンの文字色
                  minimumSize: const Size(double.infinity, 50), // 幅を画面いっぱいに
                ),
              ),
              const SizedBox(height: 10), // ボタン間のスペース
              
              // Appleサインインボタン
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                icon: const Icon(Icons.apple, size: 24),
                label: const Text('Sign In with Apple'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // ボタンの背景色
                  foregroundColor: Colors.white, // ボタンの文字色
                  minimumSize: const Size(double.infinity, 50), // 幅を画面いっぱいに
                ),
              ),
              const SizedBox(height: 10), // ボタン間のスペース

              // 新規登録ボタン
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                label: const Text('新規登録'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // ボタンの背景色
                  foregroundColor: Colors.white, // ボタンの文字色
                  minimumSize: const Size(double.infinity, 50), // 幅を画面いっぱいに
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
