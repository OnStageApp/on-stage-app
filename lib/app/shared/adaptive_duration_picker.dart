import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AdaptiveDurationPicker {
  static Future<Duration?> show({
    required BuildContext context,
    required Duration initialDuration,
  }) async {
    if (Platform.isIOS) {
      return _showCupertinoPicker(context, initialDuration);
    } else {
      return _showMaterialPicker(context, initialDuration);
    }
  }

  static Future<Duration?> _showCupertinoPicker(
    BuildContext context,
    Duration initialDuration,
  ) async {
    Duration tempDuration = initialDuration;

    final result = await showCupertinoModalPopup<Duration?>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.hm,
                            initialTimerDuration: initialDuration,
                            onTimerDurationChanged: (Duration newDuration) {
                              tempDuration = newDuration;
                            },
                          ),
                        ),
                        const Divider(height: 0.5),
                        CupertinoButton(
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(tempDuration);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result;
  }

  static Future<Duration?> _showMaterialPicker(
    BuildContext context,
    Duration initialDuration,
  ) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialDuration.inHours,
        minute: initialDuration.inMinutes % 60,
      ),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Material(
              child: Text(
                'Set Duration',
                style: context.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            ),
          ],
        );
      },
    );

    if (result != null) {
      return Duration(
        hours: result.hour,
        minutes: result.minute,
      );
    }
    return null;
  }
}
