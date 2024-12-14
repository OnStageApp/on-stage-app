import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/shared/connectivity/connectivity_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ConnectivityOverlay extends ConsumerWidget {
  const ConnectivityOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityNotifierProvider);

    if (isConnected) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Material(
        color: context.colorScheme.surface,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 64),
              Container(
                padding: const EdgeInsets.all(64),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.wifi_off,
                  size: 64,
                  color: context.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Internet Connection',
                style: context.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please check your internet connection and try again.',
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ContinueButton(
                onPressed: () {
                  ref
                      .read(connectivityNotifierProvider.notifier)
                      .checkConnectivity();
                },
                text: 'Retry',
                isEnabled: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
