import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/course_provider.dart';
import 'services/voice_service.dart';
import 'screens/hackathon_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => VoiceService()),
      ],
      child: const SenseLearnApp(),
    ),
  );
}

class SenseLearnApp extends StatelessWidget {
  const SenseLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SenseLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF339AF0),
          primary: const Color(0xFF339AF0),
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HackathonHomeScreen(),
    );
  }
}
