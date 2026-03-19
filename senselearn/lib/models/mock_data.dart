import 'course.dart';

final List<Course> mockCourses = [
  Course(
    id: '1',
    title: 'Flutter for Beginners',
    description: 'Learn the basics of Flutter and Dart by building real-world apps.',
    instructor: 'John Doe',
    thumbnail: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
    rating: 4.8,
    studentsCount: 1540,
    lessons: ['101', '102', '103'],
  ),
  Course(
    id: '2',
    title: 'Advanced UI Design',
    description: 'Master complex animations and custom painters in Flutter.',
    instructor: 'Jane Smith',
    thumbnail: 'https://images.unsplash.com/photo-1550439062-609e1531270e',
    rating: 4.9,
    studentsCount: 850,
    lessons: ['201', '202'],
  ),
  Course(
    id: '3',
    title: 'State Management with Provider',
    description: 'A deep dive into state management techniques in Flutter.',
    instructor: 'Alex Johnson',
    thumbnail: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
    rating: 4.7,
    studentsCount: 2100,
    lessons: ['301', '302', '303', '304'],
  ),
  Course(
    id: '4',
    title: 'Braille Screen Input (BSI) Basics',
    description: 'Learn how to use 6-dot Braille Screen Input on your Android device.',
    instructor: 'Accessibility Expert',
    thumbnail: 'https://images.unsplash.com/photo-1516245834210-c4c142787335',
    rating: 5.0,
    studentsCount: 120,
    lessons: ['401', '402', '403'],
  ),
];
