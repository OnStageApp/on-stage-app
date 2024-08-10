import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isObscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 148),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/onstageapp_logo.png',
                  height: 120,
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Text(
                "Get On Stage with us",
                style: context.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(height: 60),
            Column(
              children: [
                ContinueButton(
                  text: 'Login with Google',
                  onPressed: () {
                    ref.read(loginNotifierProvider.notifier).signInWithGoogle();
                  },
                  isEnabled: true,
                )
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account? ",
                  style: context.textTheme.bodyMedium,
                ),
                InkWell(
                  splashColor: lightColorScheme.surfaceTint,
                  highlightColor: lightColorScheme.surfaceTint,
                  onTap: () {},
                  child: Text(
                    "Sign up here",
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                "It takes less than a minute.",
                style: context.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
