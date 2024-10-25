import 'package:flutter/material.dart';
import 'package:seicheese/compoents/header.dart';
import 'package:seicheese/compoents/footer.dart';

class WorkListDetailScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {"id": "1", "title": "機動戦士ガンダム", "count": 5},
    {"id": "2", "title": "機動戦士Zガンダム", "count": 6},
    {"id": "3", "title": "機動戦士ガンダムZZ", "count": 2},
    {"id": "4", "title": "機動戦士ガンダム逆襲のシャア", "count": 40},
    {"id": "5", "title": "機動戦士ガンダムユニコーン", "count": 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text('ガンダムシリーズ'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 戻るボタン
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル部分
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              
              child: const Text(
                'ガンダムシリーズ',
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
                      // クリック時のアラート
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('${items[index]["title"]}がクリックされました'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
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
                          const Text(
                            '>>',
                            style: TextStyle(
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
    );
  }
}
