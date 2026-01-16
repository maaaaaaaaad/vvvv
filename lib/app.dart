import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/config/theme.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/pages/login_page.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/pages/sign_up_page.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/pages/splash_page.dart';

class JelloMarkOwnerApp extends StatelessWidget {
  const JelloMarkOwnerApp({super.key});

  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/sign-up';
  static const String mainRoute = '/main';

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
        loginRoute: (context) => const LoginPage(),
        signUpRoute: (context) => const SignUpPage(),
        mainRoute: (context) => const _MainPlaceholder(),
      },
    );
  }
}

class _MainPlaceholder extends StatelessWidget {
  const _MainPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Main Page (Coming Soon)'),
      ),
    );
  }
}
