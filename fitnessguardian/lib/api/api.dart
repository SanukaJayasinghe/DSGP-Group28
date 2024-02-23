// ignore_for_file: avoid_print, prefer_const_declarations

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  static Future<Map<String, dynamic>?> fetchData() async {
    try {
      final socket = IO.io(baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();

      socket.on('connect', (_) {
        print('WebSocket connected');
        socket.emit('fetchData');
      });

      socket.emit('fetchData');

      socket.on('data', (data) {
        print('Received data: $data');
        // Handle received data
      });

      socket.on('disconnect', (_) {
        print('WebSocket disconnected');
        // Handle connection closed
      });

      return null;
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      // Handle error
      return null;
    }
  }


  static Future<void> sendVideo(File videoFile, String videoName) async {
    try {
      final socket = IO.io(baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'options': <String, dynamic>{
          'maxHttpBufferSize': 100000000, // 100MB
        },
      });

      socket.on('videoStatus', (status) {
        print('Received status: $status');
        // Handle received status
      });

      socket.on('disconnect', (_) {
        print('WebSocket disconnected');
        // Handle connection closed
      });

      socket.connect(); // Connect before sending video

      // Read the video file as bytes
      List<int> videoBytes = await videoFile.readAsBytes();

      // Convert video bytes to base64-encoded string
      String base64Video = base64Encode(videoBytes);

      // Send video metadata and base64-encoded video data
      socket.emit('sendVideo', {
        'name': videoName,
        'file': base64Video,
      });
    } catch (e) {
      print('Error sending video: $e');
      // Handle error
    }
  }
}