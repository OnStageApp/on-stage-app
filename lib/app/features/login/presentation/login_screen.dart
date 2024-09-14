import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/gradient_background.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/image_stack.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/login_buttons_section.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/logo_widget.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/input_validator.dart'; // Import the new InputValidator class

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  bool _areCredentialsEnabled = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          if (!_areCredentialsEnabled) const ImageStack(),
          SafeArea(
            child: Padding(
              padding: defaultScreenPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      const SizedBox(height: Insets.large),
                      const LogoWidget(),
                      const SizedBox(height: 16),
                      const TitleWidget(),
                      const SizedBox(height: 64),
                      if (_areCredentialsEnabled) ...[
                        CustomTextField(
                          label: null,
                          hint: 'Email here',
                          icon: null,
                          controller: _emailController,
                          borderColor: context.colorScheme.primaryContainer,
                          validator: InputValidator.validateEmail,
                        ),
                        CustomTextField(
                          label: null,
                          hint: 'Password',
                          icon: null,
                          controller: _passwordController,
                          borderColor: context.colorScheme.primaryContainer,
                          validator: InputValidator.validatePassword,
                          obscureText: _obscureText,
                          suffixIcon: IconButton(
                            icon: Icon(
                              !_obscureText
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                              color: context.colorScheme.onSurface,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      LoginButtonsSection(
                        onContinueWithEmail: () {
                          if (!_areCredentialsEnabled) {
                            setState(() {
                              _areCredentialsEnabled = true;
                            });
                          } else {
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(loginNotifierProvider.notifier)
                                  .signInWithEmail(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
