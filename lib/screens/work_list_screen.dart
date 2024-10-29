import 'package:flutter/material.dart';
import 'package:seicheese/compoents/header.dart';
import 'package:seicheese/compoents/footer.dart';
import 'work_list_detail_screen.dart';

class WorkListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {"id": "1", "title": "仮面ライダーシリーズ", "count": 5},
    {"id": "2", "title": "ガンダムシリーズ", "count": 6},
    {"id": "3", "title": "サザエさん", "count": 2},
    {"id": "4", "title": "ドラえもん", "count": 40},
    {"id": "5", "title": "NARUTO", "count": 2},
    {"id": "6", "title": "のだめカンタービレ", "count": 40},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      // ヘッダーを表示
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // ヘッダーの高さを100に設定
        child: Header(), // Headerをここに追加
      ),   
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // 戻るボタン
                },
              ),
            // 作品一覧のタイトル
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                '作品一覧',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            // アイテムリストの表示
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // 詳細画面に遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkListDetailScreen()),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            items[index]["title"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '登録数 ${items[index]["count"]}件',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(), // フッターを表示
    );
  }
}
