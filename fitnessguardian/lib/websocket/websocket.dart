// ignore_for_file: avoid_print, library_prefixes

import 'dart:convert';
import 'dart:io';

import 'package:fitnessguardian/models/feedback.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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

  void sendDiet(Map<String, dynamic> dietData,
      void Function(dynamic message) dietCallback) {
    try {
      _ensureConnected();
      _setupDietListener(dietCallback);
      socket.emit('sendDiet', dietData);
    } catch (e) {
      print('Error sending diet data: $e');
    }
  }

  void sendVideo(
    File videoFile,
    String videoName,
    String? selectedExerciseType,
    void Function(dynamic message) videoCallback,
  ) async {
    try {
      _ensureConnected();
      _setupVideoListener(videoCallback);
      final List<int> videoBytes = await videoFile.readAsBytes();
      final String base64Video = base64Encode(videoBytes);
      socket.emit('sendVideo', {
        'name': videoName,
        'file': base64Video,
        'type': selectedExerciseType,
      });
    } catch (e) {
      print('Error sending video: $e');
    }
  }

  void _setupDietListener(void Function(dynamic message) dietCallback) {
    socket.on('dietRecommendation', (dynamic data) {
      print('Diet recommendation received');

      final dynamic recommendationData = data;

      if (recommendationData is Map<String, dynamic>) {
        final String predictedCalorie = recommendationData['predicted_calorie'].toString();
        final String recommendedIngredients =
            recommendationData['recommended_ingredients'].toString();

        final Map<String, dynamic> dietInfo = {
          'predictedCalorie': predictedCalorie,
          'recommendedIngredients': recommendedIngredients.isNotEmpty
              ? recommendedIngredients
              : 'No ingredients available',
        };

        dietCallback(dietInfo);
      }
    });
  }

  void _setupVideoListener(void Function(dynamic message) videoCallback) {
    socket.on('feedbackdata', (dynamic jsonFile) {
      print('Video feedback received');

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
          videoCallback(feedback);
        } else if (type == 'stream') {
          videoCallback(base64.decode(imageBase64));
        }
      }
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
