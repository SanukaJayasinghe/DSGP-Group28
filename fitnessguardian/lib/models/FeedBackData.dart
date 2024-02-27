import 'dart:typed_data';

class FeedbackData {
  Uint8List image;
  final String header;
  final String description;

  FeedbackData({
    required this.image,
    required this.header,
    required this.description,
  });
}