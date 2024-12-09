import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seicheese/models/content.dart';
import 'package:seicheese/services/seichi_service.dart';
import 'package:seicheese/services/auth_service.dart';
import 'package:seicheese/widgets/loading_overlay.dart';
import 'package:seicheese/screens/content_search_screen.dart';

class RegisterScreen extends StatefulWidget {
  final LatLng initialLocation;
  final Content selectedContent;

  const RegisterScreen({
    Key? key,
    required this.initialLocation,
    required this.selectedContent,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late AuthService _authService;
  late SeichiService _seichiService;
  bool _isLoading = false;
  Content? _selectedContent;

  @override
  void initState() {
    super.initState();
    _selectedContent = widget.selectedContent;
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _authService = AuthService();
      final token = await _authService.getAuthToken();
      _seichiService = SeichiService(authToken: token);
    } catch (e) {
      print('Error initializing services: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('サービスの初期化に失敗しました: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validateInput() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  Future<void> _registerSeichi() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedContent?.id == null || _selectedContent?.id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効な作品を選択してください')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _seichiService.registerSeichi(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        latitude: widget.initialLocation.latitude,
        longitude: widget.initialLocation.longitude,
        contentId: _selectedContent!.id!,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    String errorMessage = '聖地の登録に失敗しました';

    if (error.toString().contains('Duplicate entry')) {
      errorMessage = '同じ場所に既に聖地が登録されています';
    } else if (error.toString().contains('content not found')) {
      errorMessage = '選択された作品が見つかりません';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  Future<void> _selectContent() async {
    final result = await Navigator.push<Content>(
      context,
      MaterialPageRoute(builder: (context) => ContentSearchScreen()),
    );

    if (result != null) {
      setState(() {
        _selectedContent = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('聖地登録'),
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.initialLocation,
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('selected_location'),
                    position: widget.initialLocation,
                  ),
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '基本情報',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: '聖地名',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '聖地名を入力してください';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  labelText: '説明',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  hintText: '聖地に関する説明を入力してください',
                                ),
                                maxLines: null,
                                minLines: 3,
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '説明を入力してください';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '作品情報',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  if (_selectedContent != null)
                                    TextButton(
                                      onPressed: () {
                                        setState(() => _selectedContent = null);
                                      },
                                      child: const Text('クリア'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: _selectContent,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedContent?.name ??
                                              '作品を選択してください',
                                          style: TextStyle(
                                            color: _selectedContent == null
                                                ? Theme.of(context).hintColor
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _registerSeichi,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('登録する'),
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
