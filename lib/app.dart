import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/config/theme.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/pages/sign_up_page.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/pages/splash_page.dart';

class JelloMarkOwnerApp extends StatelessWidget {
  const JelloMarkOwnerApp({super.key});

  static const String splashRoute = '/';
  static const String signUpRoute = '/sign-up';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '젤로마크 사장님',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      initialRoute: splashRoute,
      routes: {
        splashRoute: (context) => const SplashPage(),
        signUpRoute: (context) => const SignUpPage(),
      },
    );
  }
}
