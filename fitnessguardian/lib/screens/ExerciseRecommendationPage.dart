// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class ExerciseRecommendationPage extends StatelessWidget {
  final Map<String, dynamic> exerciseData = {
    '1': {'name': 'Exercise 1', 'desc': 'Description for Exercise 1'},
    '2': {'name': 'Exercise 2', 'desc': 'Description for Exercise 2'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Recommendations'),
      ),
      body: exerciseData.isNotEmpty
          ? ListView.builder(
              itemCount: exerciseData.length,
              itemBuilder: (context, index) {
                final exercise = exerciseData.values.elementAt(index);
                return ExerciseListItem(
                  name: exercise['name'],
                  description: exercise['desc'],
                );
              },
            )
          : ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return SkeletonListItem();
              },
            ),
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final String name;
  final String description;

  ExerciseListItem({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        color: Colors.grey,
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
    );
  }
}

class SkeletonListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        color: Colors.grey[300],
      ),
      title: Container(
        height: 16,
        color: Colors.grey[300],
      ),
      subtitle: Container(
        height: 12,
        color: Colors.grey[300],
      ),
    );
  }
}
