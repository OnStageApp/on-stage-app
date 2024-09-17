import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/date_time_formatters.dart';

class DateTimeTextFieldWidget extends StatefulWidget {
  const DateTimeTextFieldWidget({
    required this.onDateTimeChanged,
    super.key,
    this.initialDateTime,
    this.focusNode,
    this.enabled = true,
  });

  final void Function(String?) onDateTimeChanged;
  final DateTime? initialDateTime;
  final FocusNode? focusNode;
  final bool enabled;

  @override
  State<DateTimeTextFieldWidget> createState() =>
      _DateTimeTextFieldWidgetState();
}

class _DateTimeTextFieldWidgetState extends State<DateTimeTextFieldWidget> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    dateController.addListener(_updateCombinedDateTime);
    timeController.addListener(_updateCombinedDateTime);
    _initControllers();
    super.initState();
  }

  @override
  void dispose() {
    dateController.removeListener(_updateCombinedDateTime);
    timeController.removeListener(_updateCombinedDateTime);
    super.dispose();
  }

  void _initControllers() {
    dateController.text =
        widget.initialDateTime?.toIso8601String().substring(0, 10) ?? '';
    timeController.text =
        widget.initialDateTime?.toIso8601String().substring(11, 16) ?? '';
  }

  void _updateCombinedDateTime() {
    final combinedString = '${dateController.text} ${timeController.text}';
    widget.onDateTimeChanged(combinedString);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              TextFormField(
                enabled: widget.enabled,
                focusNode: widget.focusNode,
                controller: dateController,
                style: context.textTheme.titleSmall,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  DateInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintStyle: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                  isDense: true,
                  fillColor: context.colorScheme.onSurfaceVariant,
                  filled: true,
                  hintText: 'YYYY/MM/DD',
                  suffixIcon: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(Insets.small),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: context.colorScheme.outline,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Insets.small),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: widget.enabled,
                      controller: timeController,
                      style: context.textTheme.titleSmall,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a time';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                        TimeInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintStyle: context.textTheme.titleMedium!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                        isDense: true,
                        fillColor: context.colorScheme.onSurfaceVariant,
                        filled: true,
                        hintText: 'HH:MM',
                        suffixIcon: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            borderRadius: BorderRadius.circular(Insets.small),
                          ),
                          child: Icon(
                            Icons.access_time,
                            color: context.colorScheme.outline,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Insets.small),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
