// lib/widgets/seichi_registration_dialog.dart
import 'package:flutter/material.dart';
import 'package:seicheese/models/content.dart';
import 'package:seicheese/screens/content_search_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SeichiRegistrationDialog extends StatefulWidget {
  final LatLng location;

  const SeichiRegistrationDialog({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  State<SeichiRegistrationDialog> createState() =>
      _SeichiRegistrationDialogState();
}

class _SeichiRegistrationDialogState extends State<SeichiRegistrationDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isMapReady = false;
  int? _selectedContentId;
  CameraPosition? _cameraPosition;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    setState(() {
      _isMapReady = true;
    });
  }

  void _handleSubmit() {
    if (!_isMapReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('地図の読み込みが完了するまでお待ちください')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_selectedContentId == null || _selectedContentId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('作品を選択してください')),
        );
        return;
      }

      final result = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'contentId': _selectedContentId,
        'latitude':
            _cameraPosition?.target.latitude ?? widget.location.latitude,
        'longitude':
            _cameraPosition?.target.longitude ?? widget.location.longitude,
      };

      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('聖地登録')),
      body: Stack(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.location,
                zoom: 15.0,
              ),
              onCameraMove: (CameraPosition position) {
                setState(() => _cameraPosition = position);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _handleContentSelection,
                    child: Text('作品を選択'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text('チェックイン'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleContentSelection() async {
    final result = await Navigator.push<Content>(
      context,
      MaterialPageRoute(builder: (context) => ContentSearchScreen()),
    );

    if (result != null) {
      setState(() {
        _selectedContentId = result.id;
      });
    }
  }
}
