// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class DietRecommendationPage extends StatelessWidget {
  final Map<String, dynamic> dietData = {
    '1': {'name': 'Diet 1', 'desc': 'Description for Diet 1'},
    '2': {'name': 'Diet 2', 'desc': 'Description for Diet 2'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Recommendations'),
      ),
      body: dietData.isNotEmpty
          ? ListView.builder(
              itemCount: dietData.length,
              itemBuilder: (context, index) {
                final exercise = dietData.values.elementAt(index);
                return DietListItem(
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

class DietListItem extends StatelessWidget {
  final String name;
  final String description;

  DietListItem({required this.name, required this.description});

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
