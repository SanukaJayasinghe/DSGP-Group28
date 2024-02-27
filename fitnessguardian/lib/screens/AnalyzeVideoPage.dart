import 'dart:io';
import 'package:fitnessguardian/widgets/ListBuilder.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitnessguardian/websocket/websocket.dart';
import 'package:fitnessguardian/models/FeedBackData.dart';

class AnalyzeVideoPage extends StatefulWidget {
  const AnalyzeVideoPage({super.key});

  @override
  _AnalyzeVideoPageState createState() => _AnalyzeVideoPageState();
}

class _AnalyzeVideoPageState extends State<AnalyzeVideoPage> {
  VideoPlayerController? _controller;
  String? _videoPath;
  String? _videoName;
  late WebSocket _webSocket;
  final List<FeedbackData> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _webSocket = WebSocket();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _webSocket.close();
    super.dispose();
  }

  void _connectToWebSocket() {
    _webSocket.connect(
      onMessageReceived: _handleMessageReceived,
    );
  }

  void _handleMessageReceived(dynamic message) {
    setState(() {
      _feedbackList.add(message);
    });
  }

  void _removeVideo() {
    setState(() {
      _videoPath = null;
      _videoName = null;
      _controller = null;
      _feedbackList.clear();
    });
  }

  void _requestPermissions() async {
    var status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  void _pickVideo() async {
    _removeVideo();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'],
    );
    if (result != null) {
      setState(() {
        _videoPath = result.files.single.path!;
        _videoName = result.files.single.name;
        _controller = VideoPlayerController.file(File(_videoPath!))
          ..initialize().then((_) {
            setState(() {});
            _controller!.play();
          });
      });
    }
    _webSocket.sendVideo(File(_videoPath!), _videoName!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Video'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Selected Video: ${_videoName ?? 'None'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_videoPath != null &&
                  _controller != null &&
                  _controller!.value.isInitialized)
                SizedBox(
                  height: 240,
                  width: 360,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                )
              else
                Container(
                  height: 240,
                  width: 360,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          Row(
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
          ),
          const SizedBox(height: 10),
          Text(
            'Mistakes: ${_feedbackList.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListBuilder(feedbackList: _feedbackList),
        ],
      ),
    );
  }
}
