class Lesson {
  final String id;
  final String title;
  final String duration;
  final String videoUrl;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoUrl,
    this.isCompleted = false,
  });
}
