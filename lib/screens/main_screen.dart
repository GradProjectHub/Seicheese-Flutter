import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool showPointer = false;
  bool _isLocationLoaded = false; // 位置情報がロードされるまで待機
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  final Set<Marker> _markers = {}; // マーカーのセット

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMarkers(); // 初期マーカーを読み込み
  }

  // 現在位置を取得
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLocationLoaded = true; // 現在位置がロードされた
      });
    }
  }

  // 初期状態で複数のマーカーを配置
  void _loadMarkers() {
    final List<Map<String, dynamic>> locations = [
      {
        "id": "1",
        "position": LatLng(35.6586, 139.7454),
        "title": "東京タワー",
        "snippet": "東京都港区芝公園4丁目2−8",
      },
      {
        "id": "2",
        "position": LatLng(34.9946, 135.7850),
        "title": "清水寺",
        "snippet": "京都府京都市東山区清水1丁目294",
      },
      {
        "id": "3",
        "position": LatLng(35.7100, 139.8107),
        "title": "東京スカイツリー",
        "snippet": "東京都墨田区押上1丁目1-2",
      },
    ];

    setState(() {
      for (var location in locations) {
        _markers.add(
          Marker(
            markerId: MarkerId(location["id"]),
            position: location["position"],
            infoWindow: InfoWindow(
              title: location["title"],
              snippet: location["snippet"],
            ),
          ),
        );
      }
    });
  }

  // Google Mapが作成されたときにコントローラーを設定
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_isLocationLoaded) {
      mapController.moveCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    }
  }

  // 登録ボタンの切り替え
  void togglePointer() {
    if (mounted) {
      setState(() {
        showPointer = !showPointer;
      });
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Header(),
      ),
      body: Stack(
        children: [
          // 位置情報がロードされたらGoogle Mapを表示
          if (_isLocationLoaded)
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition, // 現在位置を初期位置に設定
                zoom: 15.0,
              ),
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              markers: _markers, // マーカーを地図に表示
            ),
          // 中央のポインターと登録・キャンセルボタン
          if (showPointer)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: togglePointer,
                        child: const Text(
                          '登録',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077E6),
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: togglePointer,
                        child: const Text(
                          'キャンセル',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34495E),
                          minimumSize: const Size(120, 50),
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
              bottom: 30,
              left: 20,
              child: ElevatedButton(
                onPressed: togglePointer,
                child: const Text(
                  '登録',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077E6),
                  minimumSize: const Size(95, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
              ),
            ),

            Positioned(
              bottom: 110,
              right: 3,
              child: GestureDetector(
                onTap: () {//押したら作動
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('ポイント情報'),
                        content: const Text('現在の所有ポイントは150ptです。'),
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
                  width: 145,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '所有ポイント',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '150pt', // ここでポイント数を設定
                        style: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
          // チェックインボタン
          Positioned(
            bottom: 0,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                // サブスクリーンへの遷移処理を実装
              },
              child: const Text(
                'チェックイン',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005DB4),
                minimumSize: const Size(120, 90),
                shape: const RoundedRectangleBorder(
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
      bottomNavigationBar: const Footer(currentIndex: 1),
    );
  }
}
