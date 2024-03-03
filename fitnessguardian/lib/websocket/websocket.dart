// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fitnessguardian/models/FeedBackData.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocket {
  late IO.Socket socket;
  final String url = 'http://localhost:5000';

  WebSocket() {
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'options': <String, dynamic>{
        'maxHttpBufferSize': 100000000, // 100MB
      },
    });
  }

  void connect({required Function(dynamic) onMessageReceived}) {
    socket.on('connect', (_) {
      print('Connected to WebSocket');
    });

    socket.on('feedbackdata', (jsonFile) {
      print('Message received');
      Map<String, dynamic> data = jsonFile as Map<String, dynamic>;
      FeedbackData feedback = FeedbackData(
        image: base64Decode(data['image']),
        header: data['header'],
        description: data['description'],
      );
      onMessageReceived(feedback);
    });

    socket.on('disconnect', (_) {
      print('Disconnected from WebSocket');
    });

    socket.on('error', (error) {
      print('Socket error: $error');
    });

    socket.connect();
  }

  void close() {
    socket.disconnect();
  }

  Future<void> sendVideo(
      File videoFile, String videoName, String? selectedExerciseType) async {
    try {
      if (!socket.connected) {
        socket.connect();
      }

      socket.on('videoStatus', (status) {
        print('Received status: $status');
      });

      socket.on('disconnect', (_) {
        print('WebSocket disconnected');
      });

      List<int> videoBytes = await videoFile.readAsBytes();
      String base64Video = base64Encode(videoBytes);
      socket.emit('sendVideo', {
        'name': videoName,
        'file': base64Video,
        'type': selectedExerciseType,
      });
    } catch (e) {
      print('Error sending video: $e');
      // Handle error gracefully
    }
  }
}
