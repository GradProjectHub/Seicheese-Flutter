import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  static const int _timeoutDuration = 20;

  AuthService() {
    _initializeEnv();
  }

  Future<void> _initializeEnv() async {
    await dotenv.load();
  }

  Future<String> getAuthToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('ユーザーがログインしていません');
      }
      final token = await user.getIdToken();
      print('Auth token obtained successfully');
      return token!;
    } catch (e) {
      print('Error getting auth token: $e');
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      if (!await checkBackendHealth()) {
        throw Exception('バックエンドサーバーに接続できません');
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final token = await userCredential.user?.getIdToken();
      final appVersion = await getAppVersion();

      final response = await http
          .post(
            Uri.parse('http://${dotenv.env['LOCAL_IP_ADDR']}:1300/auth/signin'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'version': appVersion,
            }),
          )
          .timeout(const Duration(seconds: _timeoutDuration));

      if (response.statusCode == 404) {
        await signOut();
        throw Exception('ユーザーが見つかりません。サインアップしてください。');
      } else if (response.statusCode != 200) {
        final errorMessage = _parseErrorMessage(response);
        throw Exception('サインインに失敗しました: $errorMessage');
      }

      return userCredential.user;
    } on TimeoutException {
      throw Exception('接続がタイムアウトしました');
    } catch (e) {
      print('Google sign in error: $e');
      await signOut();
      rethrow;
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      if (!await checkBackendHealth()) {
        throw Exception('バックエンドサーバーに接続できません');
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final token = await userCredential.user?.getIdToken();
      final appVersion = await getAppVersion();

      final response = await http
          .post(
            Uri.parse('http://${dotenv.env['LOCAL_IP_ADDR']}:1300/auth/signup'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'version': appVersion,
            }),
          )
          .timeout(const Duration(seconds: _timeoutDuration));

      if (response.statusCode == 409) {
        throw Exception('このアカウントは既に登録されています。サインイン画面からサインインしてください。');
      } else if (response.statusCode != 201) {
        final errorMessage = _parseErrorMessage(response);
        throw Exception('サインアップに失敗しました: $errorMessage');
      }
    } on TimeoutException {
      throw Exception('接続がタイムアウトしました');
    } catch (e) {
      print('Google sign up error: $e');
      await signOut();
      rethrow;
    }
  }

  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<bool> checkBackendHealth() async {
    try {
      final response = await http.get(
        Uri.parse('http://${dotenv.env['LOCAL_IP_ADDR']}:1300/health'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('サーバーに接続できません');
      }
    } catch (e) {
      print('Backend health check error: $e');
      throw Exception('サーバーに接続できません');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  String _parseErrorMessage(http.Response response) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json['error'] ?? '不明なエラーが発生しました';
  }
}
