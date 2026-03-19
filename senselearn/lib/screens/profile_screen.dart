import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../components/accessibility_overlay.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _readProfile(BuildContext context) {
    // Simulate AI reading the profile
    final summary = mockUser.profileSummary;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("AI Voice: $summary"),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Announce profile on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readProfile(context);
    });

    return AccessibilityOverlay(
      screenName: "Your Profile and Progress",
      child: Scaffold(
        appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(mockUser.avatarUrl),
            ),
            const SizedBox(height: 20),
            Text(
              mockUser.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              mockUser.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 40, thickness: 1, indent: 20, endIndent: 20),
            _buildStatRow("Courses Completed", mockUser.completedCourses.toString()),
            _buildStatRow("Knowledge Points", mockUser.totalPoints.toString()),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () => _readProfile(context),
                icon: const Icon(Icons.record_voice_over),
                label: const Text("Read My Profile", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recent Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Braille Basics: 10%"),
                      LinearProgressIndicator(value: 0.1, color: Colors.indigo),
                      SizedBox(height: 10),
                      Text("Flutter UI: 80%"),
                      LinearProgressIndicator(value: 0.8, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
        ],
      ),
    );
  }
}
