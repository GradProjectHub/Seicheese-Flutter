import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  AuthenticationService() {
    dotenv.load(); // .envファイルの読み込み
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final token = await userCredential.user?.getIdToken();

      final appVersion = await getAppVersion();

      final response = await http.post(
        Uri.parse('http://${dotenv.env['LOCAL_IP_ADDR']}:1300/auth/signin'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'version': appVersion}),
      );

      if (response.statusCode == 404) {
        // ユーザーがデータベースに存在しない場合
        await signOut();
        throw Exception('ユーザーが見つかりません。サインアップしてください。');
      } else if (response.statusCode != 200) {
        throw Exception('サインインに失敗しました: ${response.body}');
      }

      return userCredential.user;
    } catch (e) {
      print('Google sign in error: $e');
      await signOut();
      rethrow;
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      // バックエンド接続確認
      if (!await checkBackendHealth()) {
        throw Exception('サーバーに接続できません');
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final token = await userCredential.user?.getIdToken();

      final appVersion = await getAppVersion();

      final response = await http.post(
        Uri.parse('http://${dotenv.env['LOCAL_IP_ADDR']}:1300/auth/signup'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'version': appVersion}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 409) {
        throw Exception('このアカウントは既に登録されています。サインイン画面からサインインしてください。');
      } else if (response.statusCode == 201) {
        // 成功時の処理
        final responseData = utf8.decode(response.bodyBytes);
        print('Response body (decoded): $responseData');
      } else {
        throw Exception('サインアップに失敗しました: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      await signOut();
      rethrow;
    }
  }

  Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<bool> checkBackendHealth() async {
    try {
      final response = await http
          .get(Uri.parse('http://${dotenv.env['LOCAL_IP_ADDR']}:1300/health'))
          .timeout(const Duration(seconds: 20));
      return response.statusCode == 200;
    } catch (e) {
      print('Backend health check error: $e');
      return false;
    }
  }

  // 現在のユーザー取得
  User? get currentUser => _auth.currentUser;

  // 認証状態の監視
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
