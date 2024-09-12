import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/login_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoginButtonsSection extends ConsumerWidget {
  const LoginButtonsSection({required this.onContinueWithEmail, super.key});

  final void Function() onContinueWithEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        LoginButton(
          text: 'Continue with Email',
          onPressed: onContinueWithEmail,
          isEnabled: true,
          textColor: context.colorScheme.onSurfaceVariant,
          backgroundColor: context.colorScheme.onSecondary,
          borderColor: context.colorScheme.primaryContainer,
          splashColor: context.colorScheme.surfaceBright,
        ),
        const SizedBox(height: 8),
        LoginButton(
          text: 'Continue with Google',
          onPressed: () async {
            final isSuccess = await ref
                .read(loginNotifierProvider.notifier)
                .signInWithGoogle();
            if (isSuccess) {
              context.goNamed(AppRoute.home.name);
            }
          },
          isEnabled: true,
          textColor: context.colorScheme.onSurface,
          backgroundColor: context.colorScheme.onSurfaceVariant,
          borderColor: context.colorScheme.primaryContainer,
          asset: 'assets/icons/google_sign_in.svg',
          splashColor: context.colorScheme.surfaceDim,
        ),
        const SizedBox(height: 8),
        LoginButton(
          text: 'Continue with Apple',
          onPressed: () async {
            final isSuccess = await ref
                .read(loginNotifierProvider.notifier)
                .signInWithGoogle();
            if (isSuccess) {
              context.goNamed(AppRoute.home.name);
            }
          },
          isEnabled: true,
          textColor: context.colorScheme.onSurface,
          backgroundColor: context.colorScheme.onSurfaceVariant,
          borderColor: context.colorScheme.primaryContainer,
          asset: 'assets/icons/apple_sign_in.svg',
          splashColor: context.colorScheme.surfaceDim,
        ),
      ],
    );
  }
}
