class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String thumbnail;
  final double rating;
  final int studentsCount;
  final List<String> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnail,
    required this.rating,
    required this.studentsCount,
    required this.lessons,
  });
}
