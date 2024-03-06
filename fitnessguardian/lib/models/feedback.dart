import 'dart:typed_data';

class FeedbackData {
  Uint8List imageBytes;
  final String header;
  final String description;

  FeedbackData({
    required this.imageBytes,
    required this.header,
    required this.description,
  });
}
