import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../models/mock_data.dart';

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _courses = mockCourses;
    debugPrint('Fetched ${_courses.length} courses');
    _isLoading = false;
    notifyListeners();
  }

  Course? getCourseById(String id) {
    return _courses.firstWhere((course) => course.id == id);
  }
}
