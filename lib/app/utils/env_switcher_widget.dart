import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/utils/environment_manager.dart';
import 'package:on_stage_app/logger.dart';

class EnvSwitcher extends ConsumerStatefulWidget {
  const EnvSwitcher({
    required this.child,
    super.key,
    this.requiredTaps = 10,
  });

  final Widget child;
  final int requiredTaps;

  @override
  ConsumerState<EnvSwitcher> createState() => _EnvSwitcherState();
}

class _EnvSwitcherState extends ConsumerState<EnvSwitcher> {
  int _tapCount = 0;

  void _checkAndShowEnvSwitcher() {
    if (_tapCount >= widget.requiredTaps) {
      _tapCount = 0;
      _showEnvSwitcherModal();
    }
  }

  void _showEnvSwitcherModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.developer_mode),
                title: const Text('Switch to Dev Environment'),
                onTap: () async {
                  await ref
                      .read(loginNotifierProvider.notifier)
                      .signOutAndSwitchEnv(AppEnvironment.development);

                  if (mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.production_quantity_limits),
                title: const Text('Switch to Prod Environment'),
                onTap: () async {
                  await ref
                      .read(loginNotifierProvider.notifier)
                      .signOutAndSwitchEnv(AppEnvironment.production);

                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.i('Tapped ${_tapCount + 1} times');
        setState(() {
          _tapCount++;
        });
        _checkAndShowEnvSwitcher();
      },
      child: widget.child,
    );
  }
}
