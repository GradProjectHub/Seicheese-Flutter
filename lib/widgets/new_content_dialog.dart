// lib/widgets/new_content_dialog.dart

import 'package:flutter/material.dart';
import 'package:seicheese/models/content.dart';
import 'package:seicheese/services/content_service.dart';
import 'package:seicheese/services/authentication_service.dart';
import 'package:seicheese/services/genre_service.dart';
import 'package:seicheese/models/genre.dart';

class NewContentDialog extends StatefulWidget {
  @override
  _NewContentDialogState createState() => _NewContentDialogState();
}

class _NewContentDialogState extends State<NewContentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _selectedGenreId;
  List<Genre> _genres = [];
  List<Genre> _mockGenres = [
    Genre(id: 1, name: 'アニメ'),
    Genre(id: 2, name: 'ドラマ'),
    Genre(id: 3, name: 'マンガ'),
  ];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    final authService = AuthenticationService();
    final authToken = await authService.getToken();
    final genreService = GenreService(authToken: authToken);
    try {
      final genres = await genreService.getGenres();
      if (mounted) {
        setState(() {
          _genres = genres;
          _isLoading = false;
        });
      }
      print('Fetched genres: ${_genres.map((genre) => genre.name).toList()}');
    } catch (e) {
      // ジャンルデータの取得に失敗した場合、仮データを使用
      if (mounted) {
        setState(() {
          _genres = _mockGenres;
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ジャンルデータの取得に失敗しました。仮データを使用します: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新しい作品を登録'),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '作品名',
                      hintText: '例：ドラえもん',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '作品名を入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedGenreId,
                    decoration: const InputDecoration(
                      labelText: 'ジャンル',
                      border: OutlineInputBorder(),
                    ),
                    items: _genres.map((genre) {
                      return DropdownMenuItem(
                        value: genre.id,
                        child: Text(genre.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGenreId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'ジャンルを選択してください';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newContent = Content(
                name: _nameController.text,
                genreId: _selectedGenreId!,
              );

              // コンテンツ登録APIの呼び出しを実装
              final authService = AuthenticationService();
              try {
                final authToken = await authService.getToken();
                final contentService = ContentService(authToken: authToken);
                final registeredContent =
                    await contentService.registerContent(newContent);

                // ログに出力
                print(
                    'Registered content: ${registeredContent.name}, Genre ID: ${registeredContent.genreId}');

                Navigator.pop(context, registeredContent);
              } catch (e) {
                // エラーハンドリング
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('コンテンツの登録に失敗しました: $e')),
                );
              }
            }
          },
          child: const Text('登録'),
        ),
      ],
    );
  }
}
