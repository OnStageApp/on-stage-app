import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/input_validator.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  bool _isFormValid = false;

  void _updateFormValidity() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StageAppBar(
        title: 'Change Password',
        isBackButtonVisible: true,
        background: context.colorScheme.surface,
      ),
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: Form(
          key: _formKey,
          onChanged: _updateFormValidity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Old Password',
                  hint: 'Type your current password',
                  obscureText: true,
                  icon: Icons.lock_outline,
                  controller: _oldPasswordController,
                  validator: InputValidator.validateOldPassword,
                  onChanged: (value) => _updateFormValidity(),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'New Password',
                  hint: 'Type your new password',
                  obscureText: true,
                  icon: Icons.lock,
                  controller: _newPasswordController,
                  validator: (value) => InputValidator.validateNewPassword(
                    value,
                    _oldPasswordController.text,
                  ),
                  onChanged: (value) => _updateFormValidity(),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Repeat Password',
                  hint: 'Retype your new password',
                  obscureText: true,
                  icon: Icons.lock,
                  controller: _repeatPasswordController,
                  validator: (value) => InputValidator.validateRepeatPassword(
                    value,
                    _newPasswordController.text,
                  ),
                  onChanged: (value) => _updateFormValidity(),
                ),
                const Spacer(),
                ContinueButton(
                  text: 'Change Password',
                  onPressed: _isFormValid
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            // Implement password change logic here
                            print('Password change initiated');
                          }
                        }
                      : () {},
                  isEnabled: true,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
