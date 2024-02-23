// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace, prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitnessguardian/api/api.dart';

class AnalyzeVideoPage extends StatefulWidget {
  const AnalyzeVideoPage({super.key});

  @override
  _AnalyzeVideoPageState createState() => _AnalyzeVideoPageState();
}

class _AnalyzeVideoPageState extends State<AnalyzeVideoPage> {
  VideoPlayerController? _controller;
  String? _videoPath;
  String? _videoName;

  @override
  void initState() {
    _requestPermissions();
    super.initState();
    if (_videoPath != null) {
      _controller = VideoPlayerController.file(File(_videoPath!))
        ..initialize().then((_) {
          setState(() {});
        });
    }
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      final data = await ApiService.fetchData();
      print(data);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _requestPermissions() async {
    // Request storage permission
    var status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  void _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _videoPath = result.files.single.path!;
        _videoName = result.files.single.name!;
        _controller = VideoPlayerController.file(File(_videoPath!))
          ..initialize().then((_) {
            setState(() {});
            _controller!.play();
          });
      });

      // Call the method to send video to backend
      ApiService.sendVideo(File(_videoPath!), _videoName!);
    }
  }

  void _removeVideo() {
    setState(() {
      _videoPath = null;
      _videoName = null;
      _controller = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Video'),
      ),
      body: Column(
        children: [
          if (_videoName != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _videoName!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_videoPath != null &&
              _controller != null &&
              _controller!.value.isInitialized)
            Container(
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
              margin: EdgeInsets.all(10), 
              decoration: BoxDecoration(
                color: Colors.grey[300], 
                borderRadius: BorderRadius.circular(10), 
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
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
        ],
      ),
    );
  }
}
