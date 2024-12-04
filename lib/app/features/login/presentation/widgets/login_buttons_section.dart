import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/analytics/analytics_service.dart';
import 'package:on_stage_app/app/analytics/enums/login_method.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/shared/login_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoginButtonsSection extends ConsumerWidget {
  const LoginButtonsSection({required this.onContinueWithEmail, super.key});

  final void Function() onContinueWithEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // LoginButton(
        //   text: 'Sign up with Email',
        //   onPressed: () {
        //     context.pushNamed(AppRoute.signUp.name);
        //   },
        //   isEnabled: true,
        //   textColor: context.colorScheme.onSurfaceVariant,
        //   backgroundColor: context.colorScheme.onSecondary,
        //   borderColor: context.colorScheme.primaryContainer,
        //   splashColor: context.colorScheme.surfaceBright,
        // ),
        const SizedBox(height: 8),
        if (Platform.isIOS) ...[
          Center(
            child: LoginButton(
              text: 'Continue with Apple',
              onPressed: () async {
                final notifier = ref.read(loginNotifierProvider.notifier);
                final analytics = ref.read(analyticsServiceProvider.notifier);

                final success = await notifier.signInWithApple();
                if (success && context.mounted) {
                  unawaited(analytics.logLogin(LoginMethod.apple.name));
                }
              },
              isEnabled: true,
              textColor: context.colorScheme.onSurface,
              backgroundColor: context.colorScheme.onSurfaceVariant,
              borderColor: context.colorScheme.primaryContainer,
              asset: 'assets/icons/apple_sign_in.svg',
              splashColor: context.colorScheme.surfaceDim,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Center(
          child: LoginButton(
            text: 'Continue with Google',
            onPressed: () async {
              await ref.read(loginNotifierProvider.notifier).signInWithGoogle();
            },
            isEnabled: true,
            textColor: context.colorScheme.onSurface,
            backgroundColor: context.colorScheme.onSurfaceVariant,
            borderColor: context.colorScheme.primaryContainer,
            asset: 'assets/icons/google_sign_in.svg',
            splashColor: context.colorScheme.surfaceDim,
          ),
        ),
        // const SizedBox(height: 8),
        // TextButton(
        //   onPressed: onContinueWithEmail,
        //   child: Text(
        //     'Log In',
        //     style: context.textTheme.titleMedium,
        //   ),
        // ),
      ],
    );
  }
}
