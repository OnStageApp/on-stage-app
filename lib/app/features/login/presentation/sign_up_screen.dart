import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/login_text_field.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool isObscurePassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: defaultScreenPadding.copyWith(left: 24, right: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Insets.large),
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
                      const SizedBox(height: Insets.medium),
                      Text(
                        'Sign Up',
                        style: context.textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      LoginTextField(
                        controller: _nameController,
                        label: 'Name',
                        hintText: 'Enter your full name',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                      ),
                      const SizedBox(height: Insets.medium),
                      LoginTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'example@email.com',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: Insets.medium),
                      LoginTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter your password',
                        obscureText: isObscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscurePassword = !isObscurePassword;
                            });
                          },
                          icon: Icon(
                            isObscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      Column(
                        children: [
                          ContinueButton(
                            isLoading: false,
                            text: 'Sign Up',
                            onPressed: () async {
                              final status = await ref
                                  .read(loginNotifierProvider.notifier)
                                  .signUpWithCredentials(
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                              if (status == true && mounted) {
                                unawaited(
                                  context.pushNamed(AppRoute.home.name),
                                );
                              }
                            },
                            isEnabled: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: context.textTheme.bodyMedium,
                          ),
                          InkWell(
                            splashColor: lightColorScheme.surfaceTint,
                            highlightColor: lightColorScheme.surfaceTint,
                            onTap: () {
                              context.pushNamed(AppRoute.login.name);
                            },
                            child: Text(
                              'Log in',
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Insets.large),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
