import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seicheese/compoents/footer.dart';
import 'package:seicheese/compoents/header.dart';
import 'package:seicheese/models/seichi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seicheese/screens/signin_screen.dart';
import 'package:seicheese/services/seichi_service.dart' as services;
import 'package:seicheese/screens/register_screen.dart';
import 'package:seicheese/screens/content_search_screen.dart';
import 'package:seicheese/models/content.dart';

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
  List<Seichi> _seichis = [];
  Content? _selectedContent;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchSeichis(); // 聖地データを取得してマーカーを追加
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

  // 聖地データを取得してマーカーを追加
  Future<void> _fetchSeichis() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('データを取得するにはサインインが必要です')),
      );
      // サインイン画面に遷移
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
      return;
    }

    final seichiService =
        services.SeichiService(authToken: await user.getIdToken());
    try {
      final seichis = await seichiService.getSeichies();
      setState(() {
        _seichis = seichis;
        _addMarkers(); // マーカーを追加
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('聖地データの取得に失敗しました: $e')),
      );
    }
  }

  // マーカーを追加
  void _addMarkers() {
    _markers.clear();
    for (var seichi in _seichis) {
      _markers.add(
        Marker(
          markerId: MarkerId(seichi.id.toString()),
          position: LatLng(seichi.latitude, seichi.longitude),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(seichi.name),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('作品：${seichi.contentName ?? "未設定"}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('説明：${seichi.description ?? ""}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('郵便番号：${seichi.postalCode ?? "未設定"}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('住所：${seichi.address ?? "未設定"}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('閉じる'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    }
  }

  // Google Mapが作成されたときにコントローラーを設定
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_isLocationLoaded) {
      _moveToCurrentLocation();
    }
  }

  // 現在地に移動する関数を追加
  void _moveToCurrentLocation() {
    if (_currentPosition != null && mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    }
  }

  // 登録ボタンの切り替え
  void togglePointer() {
    if (mounted) {
      setState(() {
        showPointer = !showPointer;
        if (showPointer) {
          _showContentSelectionDialog();
        }
      });
    }
  }

  // コンテンツ選択ダイアログを表示するメソッド
  Future<void> _showContentSelectionDialog() async {
    final Content? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContentSearchScreen()),
    );

    if (result != null) {
      setState(() {
        _selectedContent = result;
      });
    }
  }

  Future<void> _handleRegisterSeichi() async {
    if (_selectedContent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('先に作品を選択してください')),
      );
      return;
    }

    try {
      final position = await mapController.getVisibleRegion();
      final center = LatLng(
        (position.northeast.latitude + position.southwest.latitude) / 2,
        (position.northeast.longitude + position.southwest.longitude) / 2,
      );

      final bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen(
            initialLocation: center,
            selectedContent: _selectedContent!,
          ),
        ),
      );

      if (result == true) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _fetchSeichis();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('聖地を登録しました')),
          );
        }
      }
    } catch (e) {
      print('聖地登録エラー: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('聖地の登録に失敗しました')),
        );
      }
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
                        onPressed: () => _handleRegisterSeichi(),
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
                  '登録地の作品選択',
                  style: TextStyle(fontSize: 14, color: Colors.white),
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
              onTap: () {
                //押したら作動
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
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
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
