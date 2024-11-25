import 'package:flutter/material.dart';
import 'main_screen.dart'; // MainScreenをインポート
import 'signup_screen.dart';
import 'package:seicheese/services/authentication_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthenticationService _authService = AuthenticationService();
  bool _isSigningIn = false; // サインイン状態管理用のフラグ
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion(); // 画面表示時にバージョンを取得
  }

  // バージョン情報を取得
  Future<void> _loadAppVersion() async {
    final version = await _authService.getAppVersion();
    setState(() {
      _appVersion = version;
    });
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF070), // 背景色を指定
      body: Stack(
        children: [
          Center(
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
                  // Googleサインインボタン
                  ElevatedButton.icon(
                    onPressed: _isSigningIn
                        ? null
                        : () async {
                            await _handleSignIn();
                          },
                    icon: _isSigningIn // サインイン中はローディング表示
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
                    label: const Text('Sign In with Google'),
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
                    label: const Text('Sign In with Apple'),
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
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    label: const Text('新規登録'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // ボタンの背景色
                      foregroundColor: Colors.white, // ボタンの文字色
                      minimumSize: const Size(300, 50), // 幅を画面いっぱいに
                      elevation: 10, // ボタンに影を追加
                      shadowColor: Colors.black.withOpacity(0.5), // 影の色
                    ),
                  ),
                  const SizedBox(height: 30), // ボタン間のスペース
                ],
              ),
            ),
          ),
          // バージョン表示を右下に配置
          Positioned(
            right: 16,
            bottom: 16,
            child: Text(
              'v$_appVersion',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
