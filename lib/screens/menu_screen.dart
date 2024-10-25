import 'package:flutter/material.dart';
import 'package:seicheese/screens/work_list_screen.dart'; // 作品一覧画面をインポート
import 'package:seicheese/screens/pin_list_screen.dart'; // ピン一覧画面をインポート
import 'package:seicheese/compoents/header.dart';

class MenuScreen extends StatefulWidget {
  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  // スイッチの初期状態
  bool animeSwitch = true;
  bool mangaSwitch = true;
  bool dramaSwitch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 247, 1), // 背景色を指定 赤,緑,青,透明度
      
      // ヘッダーを表示
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // ヘッダーの高さを100に設定
        child: Header(), // Headerをここに追加
      ),    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 作品一覧とピン一覧のカード
            Expanded(
              flex: 0, // 高さを均等にする
              child: GestureDetector(
                onTap: () {
                  // 作品一覧画面に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkListScreen()),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 角丸にする
                  ),
                  elevation: 4,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 150),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '作品一覧',
                          style: TextStyle(fontSize: 18, color: Color(0xFF5DADE2)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // カード間のスペース

            // ピン一覧のカード
            Expanded(
              flex: 0, // 高さを均等にする
              child: GestureDetector(
                onTap: () {
                  // ピン一覧画面に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PinListScreen()),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 角丸にする
                  ),
                  elevation: 4,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 150),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ピン一覧',
                          style: TextStyle(fontSize: 18, color: Color(0xFF5DADE2)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // カード間のスペース

            // マップ設定のカード
            Expanded(
              flex: 0, // 高さを均等にする
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'マップ設定',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF34495E)),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '聖地の非表示',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('アニメ', style: TextStyle(fontSize: 16)),
                          Switch(
                            value: animeSwitch,
                            onChanged: (value) {
                              setState(() {
                                animeSwitch = value;
                              });
                            },
                            activeColor: const Color(0xFF5DADE2),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('マンガ', style: TextStyle(fontSize: 16)),
                          Switch(
                            value: mangaSwitch,
                            onChanged: (value) {
                              setState(() {
                                mangaSwitch = value;
                              });
                            },
                            activeColor: const Color(0xFF5DADE2),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ドラマ', style: TextStyle(fontSize: 16)),
                          Switch(
                            value: dramaSwitch,
                            onChanged: (value) {
                              setState(() {
                                dramaSwitch = value;
                              });
                            },
                            activeColor: const Color(0xFF5DADE2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
