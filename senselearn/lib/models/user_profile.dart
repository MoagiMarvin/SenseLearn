class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final int completedCourses;
  final int totalPoints;
  final Map<String, double> courseProgress; // courseId -> percentage (0.0 to 1.0)

  UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.completedCourses = 0,
    this.totalPoints = 0,
    this.courseProgress = const {},
  });

  String get profileSummary => 
    "Profile of $name. You have completed $completedCourses courses and earned $totalPoints points.";
}

final UserProfile mockUser = UserProfile(
  name: "Marvin",
  email: "marvin@example.com",
  avatarUrl: "https://api.dicebear.com/7.x/avataaars/svg?seed=Alex",
  completedCourses: 5,
  totalPoints: 1250,
  courseProgress: {
    '1': 1.0,
    '2': 0.8,
    '3': 0.4,
    '4': 0.1, // Braille course progress
  },
);
