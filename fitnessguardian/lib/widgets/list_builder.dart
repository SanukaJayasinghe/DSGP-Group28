import 'package:fitnessguardian/models/feedback.dart';
import 'package:fitnessguardian/screens/list_item_page.dart';
import 'package:flutter/material.dart';

/// This widget builds a list of feedback items.
class ListBuilder extends StatelessWidget {
  final List<FeedbackData> feedbackList;

  const ListBuilder({super.key, required this.feedbackList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = feedbackList[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListItemPage(
                      image: feedback.imageBytes,
                      header: feedback.header,
                      description: feedback.description,
                    ),
                  ),
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.memory(
                  feedback.imageBytes,
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(
                feedback.header,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                _truncateDescription(feedback.description),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Truncates the description string if it's longer than the specified [maxLength].
  String _truncateDescription(String description, {int maxLength = 30}) {
    return description.length > maxLength
        ? '${description.substring(0, maxLength)}...'
        : description;
  }
}
