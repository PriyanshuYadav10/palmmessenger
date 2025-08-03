import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/features/presentation/screens/auth/LoginScreen.dart';
import 'package:palmmessenger/features/presentation/utility/global.dart';
import 'package:palmmessenger/features/presentation/utility/gradient_text.dart';
import 'package:uuid/uuid.dart';

import '../../../config/theme/app_themes.dart';
import '../../../core/constants/images.dart';
import '../../data/encryption/rsa_helper.dart';
import '../../data/encryption/rsa_key_helper.dart';
import '../../data/model/user_model.dart';
import '../../helper/database_service.dart';
import '../../helper/websocket_service.dart';
import '../utility/app_shared_prefrence.dart';
import 'Dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  @override
  void initState() {
    super.initState(); _controller.forward();
    accessToken= '';
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _controller.stop();
        final prefs = AppSharedPref();
        final userData = await prefs.read("userData");
        print(userData.runtimeType);
        if (userData != null&&userData!='') {
          // Optionally decode it if it's JSON-encoded
          print('User is logged in: $userData');
          accessToken = userData['accessToken'].toString();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(),
            ),
          );
        } else {
          print('No user found, navigating to login.');
          accessToken= '';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.blackColor,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Image.asset(splashLogo),
            ),
          ),
          hSpace(250),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(scale: _animation.value, child: child);
              },
              child: Center(
                child: GradientText(
                  'Palm Messenger',
                  style: Styles.semiBoldTextStyle(size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
