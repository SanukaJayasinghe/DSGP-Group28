// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitnessguardian/websocket/websocket.dart';
import 'package:fitnessguardian/models/feedback.dart';
import 'package:fitnessguardian/widgets/list_builder.dart';

class AnalyzeVideoPage extends StatefulWidget {
  const AnalyzeVideoPage({super.key});

  @override
  _AnalyzeVideoPageState createState() => _AnalyzeVideoPageState();
}

class _AnalyzeVideoPageState extends State<AnalyzeVideoPage> {
  String? _videoPath;
  String? _videoName;
  String? _selectedExerciseType;
  late Uint8List? _videoStream;
  late WebSocket _webSocket;
  final List<FeedbackData> _feedbackList = [];
  final List<String> _dropdownItems = [
    'Pushup',
    'Situp',
    'Squat',
    'Pullup',
    'Mountain Climbing',
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _webSocket = WebSocket();
    _videoStream = null;
  }

  @override
  void dispose() {
    _webSocket.close();
    super.dispose();
  }

  void _requestPermissions() async {
    final status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  void _pickVideo() async {
    _removeVideo();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'],
    );
    if (result != null) {
      setState(() {
        _videoPath = result.files.single.path!;
        _videoName = result.files.single.name;
      });
    }
    _webSocket.sendVideo(
      File(_videoPath!),
      _videoName!,
      _selectedExerciseType,
      _handleMessageReceived,
    );
  }

  void _handleMessageReceived(dynamic message) {
    setState(() {
      if (message is FeedbackData) {
        _feedbackList.add(message);
      } else if (message is Uint8List) {
        _videoStream = message;
      }
    });
  }

  void _removeVideo() {
    setState(() {
      _videoPath = null;
      _videoName = null;
      _videoStream = null;
      _feedbackList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posture Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildExerciseTypeSelector(),
            const SizedBox(height: 10),
            _buildVideoPlayer(),
            const SizedBox(height: 10),
            _buildButtonsRow(),
            const SizedBox(height: 10),
            _buildFeedbackInfo(),
            const SizedBox(height: 10),
            Expanded(
              child: ListBuilder(feedbackList: _feedbackList),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildExerciseTypeSelector() {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: 'Exercise Type',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    value: _selectedExerciseType ??= _dropdownItems.first,
    onChanged: (String? newValue) {
      setState(() {
        _selectedExerciseType = newValue;
      });
    },
    items: _dropdownItems.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

  Widget _buildVideoPlayer() {
    return Container(
      height: 240,
      width: 360,
      decoration: BoxDecoration(
        color: _videoStream != null ? Colors.white : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _videoStream != null
            ? AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.memory(
                  _videoStream!,
                  fit: BoxFit.contain,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _pickVideo,
          child: const Text('Choose Video'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _removeVideo,
          child: const Text('Remove Video'),
        ),
      ],
    );
  }

  Widget _buildFeedbackInfo() {
    return Text(
      'Mistakes: ${_feedbackList.length}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
