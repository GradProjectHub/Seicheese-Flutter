// lib/screens/content_search_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seicheese/models/content.dart';
import 'package:seicheese/services/content_service.dart';
import 'package:seicheese/widgets/new_content_dialog.dart';
import 'dart:async';

class ContentSearchScreen extends StatefulWidget {
  const ContentSearchScreen({Key? key}) : super(key: key);

  @override
  _ContentSearchScreenState createState() => _ContentSearchScreenState();
}

class _ContentSearchScreenState extends State<ContentSearchScreen> {
  final _searchController = TextEditingController();
  List<Content> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;
  ContentService? _contentService;

  @override
  void initState() {
    super.initState();
    _initializeContentService();
  }

  Future<void> _initializeContentService() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    if (token != null) {
      _contentService = ContentService(authToken: token);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      setState(() => _isSearching = true);

      try {
        if (_contentService == null) {
          await _initializeContentService();
        }

        final results = await _contentService?.searchContents(query) ?? [];
        if (mounted) {
          setState(() {
            _searchResults = results;
            _isSearching = false;
          });
        }
      } catch (e) {
        print('Error searching contents: $e');
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('検索中にエラーが発生しました: $e')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('作品を検索'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: '作品名を入力',
                hintText: '検索したい作品名を入力してください',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? const Center(
                        child: Text('検索結果がありません'),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final content = _searchResults[index];
                          return ListTile(
                            title: Text(content.name),
                            subtitle: Text(content.genreName ?? ''),
                            onTap: () {
                              // ログに出力
                              print(
                                  'Selected content: ${content.name}, Genre ID: ${content.genreId}');
                              Navigator.pop(context, content);
                            },
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final newContent = await showDialog<Content>(
                  context: context,
                  builder: (context) => NewContentDialog(),
                );
                if (newContent != null) {
                  Navigator.pop(context, newContent);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('新しい作品を登録'),
            ),
          ),
        ],
      ),
    );
  }
}
