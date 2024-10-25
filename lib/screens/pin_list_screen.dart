import 'package:flutter/material.dart';
import 'package:seicheese/compoents/footer.dart';
import 'package:seicheese/compoents/header.dart';

class PinListScreen extends StatefulWidget {
  @override
  _PinListScreenState createState() => _PinListScreenState();
}

class _PinListScreenState extends State<PinListScreen> {
  bool modalVisible = false;
  int selectedPinIndex = 0;

  // ピン画像リスト
  final List<Map<String, dynamic>> pinImages = [
    {'image': 'assets/pin/pin_1.png', 'points': 100},
    {'image': 'assets/pin/pin_2.png', 'points': 100},
    {'image': 'assets/pin/pin_3.png', 'points': 100},
    {'image': 'assets/pin/pin_4.png', 'points': 100},
    {'image': 'assets/pin/pin_5.png', 'points': 100},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF070),
      // ヘッダーを表示
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // ヘッダーの高さ
        child: Header(), // Header コンポーネント
      ),
      body: Stack(
        children: [
          // グリッドビューでピンを表示
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: pinImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPinIndex = index;
                      modalVisible = true;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                pinImages[selectedPinIndex]['image'],
                                width: 100,
                                height: 100,
                              ),
                              SizedBox(height: 20),
                              Text(
                                '${pinImages[selectedPinIndex]['points']}pt',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'このピンを交換しますか？',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        modalVisible = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('はい', style: TextStyle(fontSize: 18)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        modalVisible = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('いいえ', style: TextStyle(fontSize: 18)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 3.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          pinImages[index]['image'],
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${pinImages[index]['points']}pt',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
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
      bottomNavigationBar: Footer(), // フッターを表示
    );
  }
}
