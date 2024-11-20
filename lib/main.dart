import 'package:flutter/material.dart';
import 'package:seicheese/screens/signin_screen.dart'; // SignInScreenをインポート
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

// ...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  // ログレベルを設定
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seicheese',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(), // サインイン画面を最初の画面に設定
    );
  }
}
