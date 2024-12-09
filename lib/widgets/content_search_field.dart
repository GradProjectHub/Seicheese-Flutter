// lib/widgets/content_search_field.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seicheese/models/content.dart';
import 'package:seicheese/services/content_service.dart';

class ContentSearchField extends StatefulWidget {
  final Function(Content) onSelected;
  final Content? initialContent;

  const ContentSearchField({
    Key? key,
    required this.onSelected,
    this.initialContent,
  }) : super(key: key);

  @override
  State<ContentSearchField> createState() => _ContentSearchFieldState();
}

class _ContentSearchFieldState extends State<ContentSearchField> {
  final _searchController = TextEditingController();
  ContentService? _contentService;
  List<Content> _searchResults = [];
  bool _isSearching = false;
  Content? _selectedContent;

  @override
  void initState() {
    super.initState();
    _selectedContent = widget.initialContent;
    if (_selectedContent != null) {
      _searchController.text = _selectedContent!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedContent != null) {
      return ListTile(
        title: Text(_selectedContent!.name),
        subtitle: Text(_selectedContent!.genreName ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _selectedContent = null;
              _searchController.clear();
            });
          },
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: '作品名を入力',
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
                  ? const Center(child: Text('検索結果がありません'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final content = _searchResults[index];
                        return ListTile(
                          title: Text(content.name),
                          subtitle: Text(content.genreName ?? ''),
                          onTap: () => Navigator.pop(context, content),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();
      if (token == null) {
        throw Exception('認証トークンの取得に失敗しました');
      }
      _contentService = ContentService(authToken: token);
      final results = await _contentService!.searchContents(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching contents: $e');
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }
}
