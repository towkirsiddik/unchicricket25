import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unchi_cricket/controllers/main_controller.dart';
import 'package:unchi_cricket/screens/home_screen.dart';
import 'package:unchi_cricket/screens/news_screen.dart';
import 'package:unchi_cricket/screens/sponsors_screen.dart';
import 'package:unchi_cricket/screens/teams_screen.dart';
import 'package:unchi_cricket/screens/tournament_screen.dart';
import 'package:unchi_cricket/utils/colors.dart';
import 'package:unchi_cricket/widgets/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Fullscreen / hide system navigation buttons
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Local Cricket League',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            top: true,
            bottom: false, // bottom nav এর জন্য false
            child: Obx(() {
              switch (controller.currentIndex.value) {
                case 0:
                  return const HomeScreen();
                case 1:
                  return const TournamentScreen();
                case 2:
                  return const TeamsScreen();
                case 3:
                  return const NewsScreen();
                case 4:
                  return const SponsorsScreen();
                default:
                  return const HomeScreen();
              }
            }),
          ),

          // Developer credit overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              child: const Text(
                'Made by Towkir Siddik',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
