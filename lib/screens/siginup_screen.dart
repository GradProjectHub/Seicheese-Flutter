import 'package:flutter/material.dart';
import 'main_screen.dart'; // MainScreenをインポート
import 'signin_screen.dart';

class SignUpScreen extends StatelessWidget {
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
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Image.asset(
                  'assets/icons/logo.jpg', // ロゴ画像を表示
                  height: 230,
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
                label: const Text('Sign Up with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // ボタンの背景色
                  foregroundColor: Colors.black, // ボタンの文字色
                  minimumSize: const Size(double.infinity, 50), // 幅を画面いっぱいに
                  elevation: 10, // ボタンに影を追加
                  shadowColor: Colors.black.withOpacity(0.5), // 影の色
                ),
              ),
              const SizedBox(height: 20), // ボタン間のスペース
              
              // Appleサインインボタン
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                icon: const Icon(Icons.apple, size: 24),
                label: const Text('Sign Up with Apple'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // ボタンの背景色
                  foregroundColor: Colors.white, // ボタンの文字色
                  minimumSize: const Size(double.infinity, 50), // 幅を画面いっぱいに
                  elevation: 10, // ボタンに影を追加
                  shadowColor: Colors.black.withOpacity(0.5), // 影の色
                ),
              ),
              const SizedBox(height: 60), // ボタン間のスペース

              // 新規登録ボタン
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                label: const Text('戻る'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // ボタンの背景色
                  foregroundColor: Colors.white, // ボタンの文字色
                  minimumSize: const Size(150, 50), // 幅を画面いっぱいに
                  elevation: 10, // ボタンに影を追加
                  shadowColor: Colors.black.withOpacity(0.5), // 影の色
                ),
              ),
              const SizedBox(height: 30), // ボタン間のスペース
            ],
          ),
        ),
      ),
    );
  }
}
