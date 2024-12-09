import 'package:flutter/material.dart';
import 'main_screen.dart'; // MainScreenをインポート
import 'signin_screen.dart';
import '../services/authentication_service.dart';

class SignUpScreen extends StatefulWidget {
  // StatefulWidgetを継承
  @override
  _SignUpScreenState createState() =>
      _SignUpScreenState(); // _SignUpScreenStateを返す
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthenticationService _authService = AuthenticationService();
  bool _isSigningUp = false; // サインアップ中かどうかのフラグ

  Future<void> _handleSignUp() async {
    if (_isSigningUp) return;

    setState(() {
      _isSigningUp = true;
    });

    try {
      await _authService.signUpWithGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          action: e.toString().contains('既に登録されています')
              ? SnackBarAction(
                  label: 'サインイン画面へ',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                )
              : null,
        ),
      );
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

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
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  'assets/icons/logo.jpg', // ロゴ画像を表示
                  height: 230,
                ),
              ),
              const Text(
                '新規登録',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 20), // テキスト間のスペース

              // Googleサインインボタン
              ElevatedButton.icon(
                onPressed: _isSigningUp
                    ? null
                    : () async {
                        await _handleSignUp();
                      },
                icon: _isSigningUp // サインイン中はローディング表示
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Image.asset(
                        'assets/icons/google-icon.png', // Googleアイコン
                        height: 24,
                      ),
                label: Text(_isSigningUp ? '処理中...' : 'Sign Up with Google'),
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
                label: const Text('登録済みの方はこちら'),
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
