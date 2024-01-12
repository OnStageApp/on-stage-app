import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/common_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: defaultScreenPadding,
        child: Column(
          children: [
            const SizedBox(height: 148),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/onstageapp_logo.png',
                height: 120,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Get On Stage with us',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 48),
            const CommonTextField(
              hintText: 'Email',
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            CommonTextField(
              hintText: 'Password',
              obscureText: isObscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(
                    () {
                      isObscurePassword = !isObscurePassword;
                    },
                  );
                },
                icon: Icon(
                  isObscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child:
                  Text('Forgot password?', style: context.textTheme.bodyMedium),
            ),
            const SizedBox(height: 60),
            Column(
              children: [
                InkWell(
                  splashColor: lightColorScheme.surfaceTint,
                  highlightColor: lightColorScheme.surfaceTint,
                  onTap: () {},
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Center(
                      child: Text(
                        'Log in',
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'or',
                  style: context.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                InkWell(
                  splashColor: lightColorScheme.surfaceTint,
                  highlightColor: lightColorScheme.surfaceTint,
                  onTap: () {},
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'Log in with Google',
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                // ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don’t have an account? ',
                  style: context.textTheme.bodyMedium,
                ),
                InkWell(
                  splashColor: lightColorScheme.surfaceTint,
                  highlightColor: lightColorScheme.surfaceTint,
                  onTap: () {},
                  child: Text(
                    'Sign up here',
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            Text(
              'It takes less than a minute.',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
