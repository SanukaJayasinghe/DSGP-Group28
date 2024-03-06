// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DietRecommendationPage extends StatefulWidget {
  const DietRecommendationPage({super.key});

  @override
  _DietRecommendationPageState createState() => _DietRecommendationPageState();
}

class _DietRecommendationPageState extends State<DietRecommendationPage> {
  final Map<String, dynamic> dietData = {
    '1': {'name': 'Diet 1', 'desc': 'Description for Diet 1'},
    '2': {'name': 'Diet 2', 'desc': 'Description for Diet 2'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: dietData.isNotEmpty
            ? ListView.builder(
                itemCount: dietData.length,
                itemBuilder: (context, index) {
                  final diet = dietData.values.elementAt(index);
                  return DietListItem(
                    name: diet['name'] as String,
                    description: diet['desc'] as String,
                  );
                },
              )
            : ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const SkeletonItem();
                },
              ),
      ),
    );
  }
}

class DietListItem extends StatelessWidget {
  final String name;
  final String description;

  const DietListItem({
    super.key,
    required this.name,
    required this.description,
  });

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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
    );
  }
}

class SkeletonItem extends StatelessWidget {
  const SkeletonItem({super.key});

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