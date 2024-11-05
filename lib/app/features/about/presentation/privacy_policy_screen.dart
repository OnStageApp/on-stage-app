import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/about/data/data.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const StageAppBar(
        title: 'Privacy Policy',
        isBackButtonVisible: true,
      ),
      body: Markdown(
        data: privacyPolicyText,
        styleSheet: MarkdownStyleSheet(
          h1: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
          h2: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          h3: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          p: theme.textTheme.bodyLarge,
          listBullet: theme.textTheme.bodyLarge,
        ),
        onTapLink: (text, href, title) {
          // if (href != null) {
          //   launchUrl(Uri.parse(href));
          // }
        },
      ),
    );
  }
}
