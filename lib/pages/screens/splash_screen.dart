import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/extensions/extensions.dart';
import 'package:untitled/pages/screens/login_screen.dart';
import 'package:untitled/pages/screens/main_frame_screen.dart';
import 'package:untitled/states/stores/auth/auth_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void _checkLogin() {
    final auth = ref.read(authProvider);

    context.pushAndRemoveUntil(
      auth != null ? MainFrameScreen() : LoginScreen(),
      (route) => false,
      transition: false,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: CircularProgressIndicator.adaptive(
        constraints: BoxConstraints.expand(width: 60, height: 60),
      ),
    );
  }
}
