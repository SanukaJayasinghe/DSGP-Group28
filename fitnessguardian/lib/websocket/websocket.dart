// ignore_for_file: avoid_print, library_prefixes

import 'dart:convert';
import 'dart:io';

import 'package:fitnessguardian/models/feedback.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// This class handles WebSocket communication.
class WebSocket {
  late IO.Socket socket;
  final String url = 'http://localhost:5000';

  WebSocket() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(
      url,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'options': <String, dynamic>{
          'maxHttpBufferSize': 100000000, // 100MB
        },
      },
    );
    socket.connect();
  }

  Future<void> sendVideo(
    File videoFile,
    String videoName,
    String? selectedExerciseType,
    void Function(dynamic message) handleMessageReceived,
  ) async {
    try {
      _ensureConnected();
      _setupListeners(handleMessageReceived);
      final List<int> videoBytes = await videoFile.readAsBytes();
      final String base64Video = base64Encode(videoBytes);
      socket.emit('sendVideo', {
        'name': videoName,
        'file': base64Video,
        'type': selectedExerciseType,
      });
    } catch (e) {
      // Handle error appropriately
      print('Error sending video: $e');
    }
  }

  void _setupListeners(void Function(dynamic message) handleMessageReceived) {
    socket.on('connect', (_) {
      // Log connection success
      print('Connected to WebSocket');
    });

    socket.on('feedbackdata', (dynamic jsonFile) {
      // Log message received
      print('Message received');

      final dynamic data = jsonFile;
      
      if (data is Map<String, dynamic>) {
        final String type = data['type'];
        final String imageBase64 = data['image'];
        final String header = data['header'];
        final String description = data['description'];

        if (type == 'wrong') {
          final FeedbackData feedback = FeedbackData(
            imageBytes: base64.decode(imageBase64),
            header: header,
            description: description,
          );
          handleMessageReceived(feedback);
        } 
        else if (type == 'stream') {
          handleMessageReceived(base64.decode(imageBase64));
        }
      }
    });

    socket.on('error', (error) {
      // Log socket error
      print('Socket error: $error');
    });

    socket.on('videoStatus', (status) {
      // Log received status
      print('Received status: $status');
    });

    socket.on('disconnect', (_) {
      // Log WebSocket disconnection
      print('WebSocket disconnected');
    });
  }

  void _ensureConnected() {
    if (!socket.connected) {
      socket.connect();
    }
  }

  void close() {
    socket.disconnect();
  }
}
