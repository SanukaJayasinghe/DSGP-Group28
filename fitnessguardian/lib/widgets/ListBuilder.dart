import 'package:fitnessguardian/models/FeedBackData.dart';
import 'package:fitnessguardian/screens/ListItemPage.dart';
import 'package:flutter/material.dart';

class ListBuilder extends StatelessWidget {
  final List<FeedbackData> feedbackList;

  const ListBuilder({Key? key, required this.feedbackList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 293,
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
            // height: 120,
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListItemPage(
                      image: feedback.image,
                      header: feedback.header,
                      description: feedback.description,
                    ),
                  ),
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.memory(
                  feedback.image,
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
  String _truncateDescription(String description) {
    return description.length > 30
        ? '${description.substring(0, 30)}...'
        : description;
  }
}