import 'package:flutter/material.dart';
import 'package:seicheese/compoents/footer.dart';
import 'package:seicheese/compoents/header.dart';

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
  bool showPointer = false;

  // 登録ボタンの切り替え
  void togglePointer() {
    setState(() {
      showPointer = !showPointer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F2F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Header(),
      ),
      body: Stack(
        children: [
          // 中央のポインターと登録・キャンセルボタン
          if (showPointer)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: togglePointer,
                        child: Text(
                          '登録',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0077E6),
                          minimumSize: Size(120, 50), // 同じサイズに設定
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: togglePointer,
                        child: Text(
                          'キャンセル',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF34495E),
                          minimumSize: Size(120, 50), // 同じサイズに設定
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // 左下の登録ボタン（ポインター表示時に非表示）
          if (!showPointer)
            Positioned(
              bottom: 0,
              left: 20,
              child: ElevatedButton(
                onPressed: togglePointer,
                child: Text(
                  '登録',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0077E6),
                  minimumSize: Size(95, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          // チェックインボタン
          Positioned(
            bottom: 0,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // サブスクリーンへの遷移処理を実装
              },
              child: Text(
                'チェックイン',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF005DB4),
                minimumSize: Size(120, 90),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
