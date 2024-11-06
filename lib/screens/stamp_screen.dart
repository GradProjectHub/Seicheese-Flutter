import 'package:flutter/material.dart';
import 'package:seicheese/compoents/header.dart';
import 'package:seicheese/compoents/footer.dart';


class StampScreen extends StatefulWidget {
  const StampScreen({super.key});

  @override
  State<StampScreen> createState() => StampScreenState();
}

class StampScreenState extends State<StampScreen> {
  // 1ページに表示するスタンプの数
  final int stampsPerPage = 20;
  int currentPage = 1;

  // スタンプの画像パスの配列
  final List<String> stampImages = [
    'assets/stamp/stamp.png',
    'assets/stamp/stamp.png',
    'assets/stamp/stamp.png',
    // ...他の画像パスを追加
  ];

  // スタンプデータの取得
  List<Map<String, dynamic>> getDisplayedStamps() {
    int startIndex = (currentPage - 1) * stampsPerPage;
    int endIndex = startIndex + stampsPerPage;
    
    if (endIndex > stampImages.length) {
      endIndex = stampImages.length;
    }
    
    return stampImages
        .sublist(startIndex, endIndex)
        .asMap()
        .map((index, image) => MapEntry(index, {
              'id': index,
              'image': image,
            }))
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (stampImages.length / stampsPerPage).ceil();
    final displayedStamps = getDisplayedStamps();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // ヘッダーの高さを100に設定
        child: Header(), // Headerをここに追加
      ),      
      body: Container(
        color: const Color(0xFFFFF070),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 120,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: displayedStamps.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 3.84,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                displayedStamps[index]['image'],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error); // 画像が見つからない場合にエラーアイコンを表示
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          totalPages,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                currentPage = index + 1;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: currentPage == index + 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: currentPage == index + 1
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(currentIndex: 0), 
    );
  }
}
