import 'package:flutter/material.dart';
import 'main_screen.dart'; // MainScreenをインポート
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'siginup_screen.dart';

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
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  'assets/icons/logo.jpg', // ロゴ画像を表示
                  height: 230,
                ),
              ),
              // Googleサインインボタン
              ElevatedButton.icon(
                onPressed: () async {
                  // Googleサインイン
                  GoogleSignInAccount? siginAccount =
                      await GoogleSignIn().signIn();
                  if (siginAccount == null) return;
                  GoogleSignInAuthentication auth =
                      await siginAccount.authentication;

                  final OAuthCredential credential =
                      GoogleAuthProvider.credential(
                    idToken: auth.idToken,
                    accessToken: auth.accessToken,
                  );

                  //認証情報をFirebaseに登録
                  User? user = (await FirebaseAuth.instance
                          .signInWithCredential(credential))
                      .user;
                  // ログイン成功時はメイン画面に遷移
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  }
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
    );
  }
}
