// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fitnessguardian/screens/analyze_video_page.dart';
import 'package:fitnessguardian/screens/exercise_recommendation_page.dart';
import 'package:fitnessguardian/screens/diet_recommendation_page.dart';
import 'package:fitnessguardian/screens/profile_page.dart';

/// This widget represents the main navigation of the application.
class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        fontFamily: 'Poppins',
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const AnalyzeVideoPage(),
    const ExerciseRecommendationPage(),
    const DietRecommendationPage(),
    const ProfilePage(),
  ];

  // Method to handle bottom navigation bar tap
  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey[800],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Analyze',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exercise),
              label: 'Exercise',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Diet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
