import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_providers.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_state.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final String loginRoute;

  const AuthGuard({
    super.key,
    required this.child,
    this.loginRoute = '/login',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return switch (authState) {
      AuthInitial() || AuthLoading() => _buildLoadingState(),
      AuthAuthenticated() => child,
      AuthUnauthenticated() => _buildUnauthenticatedState(context),
      AuthError(message: final message) => _buildErrorState(context, ref, message),
    };
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildUnauthenticatedState(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, loginRoute);
    });

    return _buildLoadingState();
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).checkAuthStatus();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
