import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/common_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword =
      true; // Add this variable to manage password visibility

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 10),
        child: Column(
          children: [
            SizedBox(
              height: height / 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16), // Adjust the radius to control corner roundness
              child: Image.asset(
                'assets/images/onstageapp_logo.png',
                height: 120,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: height / 20,
            ),
            Text(
              "Get On Stage with us",
              style: context.textTheme.titleLarge,
            ),
            SizedBox(
              height: height / 20,
            ),
            const CommonTextField(
              hintText: "Email",
              // onChanged: () {},
              // errorString: "error",
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: height / 50,
            ),
            CommonTextField(
              hintText: "Password",
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  // Toggle password visibility
                  setState(
                    () {
                      obscurePassword = !obscurePassword;
                    },
                  );
                },
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child:
                  Text('Forgot password?', style: context.textTheme.bodyMedium),
            ),
            SizedBox(
              height: height / 60,
            ),
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
                        color: Theme.of(context).colorScheme.secondary),
                    child: Center(
                      child: Text(
                        "Log in",
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "or",
                  style: context.textTheme.labelLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  splashColor: lightColorScheme.surfaceTint,
                  highlightColor: lightColorScheme.surfaceTint,
                  onTap: () {},
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Assets.icons.group.svg(width: 16, height: 16),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Log in with Google",
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
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
            Text(
              "It takes less than a minute.",
              style: context.textTheme.bodyMedium,
            ),
            SizedBox(
              height: height / 30,
            )
          ],
        ),
      ),
    );
  }
}
