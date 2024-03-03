// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore
import 'package:flutter/material.dart';
import 'package:fitnessguardian/screens/AnalyzeVideoPage.dart';
import 'package:fitnessguardian/screens/ExerciseRecommendationPage.dart';
import 'package:fitnessguardian/screens/DietRecommendationPage.dart';
import 'package:fitnessguardian/screens/ProfilePage.dart';

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
    AnalyzeVideoPage(),
    ExerciseRecommendationPage(),
    DietRecommendationPage(),
    ProfilePage(),
  ];

  // Method to handle bottom navigation bar tap
  void _onItemTapped(int index) {
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
        decoration: BoxDecoration(
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
              icon: Icon(Icons.fitness_center),
              label: 'Exercise',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Diet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
