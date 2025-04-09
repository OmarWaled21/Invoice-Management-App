import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/home_screen.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward().then((_) {
      // Navigate to the home screen after the animation
      Get.offAll(() => const HomeScreen());
    });

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;
    return Scaffold(
      body: Container(
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.assetsLogo,
                  width: mq.width * 0.5,
                  isAntiAlias: true,
                  color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to Facturation Intuitive',
                  style: TextStyle(
                    fontSize: mq.aspectRatio * 50,
                    fontWeight: FontWeight.bold,
                    color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
