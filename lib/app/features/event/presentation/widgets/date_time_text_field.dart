import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late DateTime _now;
  late DateTime _minimumDateTime;
  late DateTime _maximumDateTime;

  final GlobalKey _datePickerKey = GlobalKey();
  final GlobalKey _timePickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _now = DateTime.now();
    _selectedDate = widget.initialDateTime;
    _selectedTime = widget.initialDateTime != null
        ? TimeOfDay.fromDateTime(widget.initialDateTime!)
        : null;

    _minimumDateTime = _now.subtract(const Duration(days: 40));
    _maximumDateTime = _now.add(const Duration(days: 365));
  }

  void _updateCombinedDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime combinedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      String formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(combinedDateTime);

      print('Formatted DateTime: $formattedDateTime');


      widget.onDateTimeChanged(formattedDateTime);
    }
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    _updateCombinedDateTime();
  }

  void _onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _selectedTime = newTime;
    });
    _updateCombinedDateTime();
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Picker Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              InkWell(
                key: _datePickerKey,
                onTap: () {
                  final renderBox = _datePickerKey.currentContext
                      ?.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    showCupertinoCalendarPicker(
                      context,
                      widgetRenderBox: renderBox,
                      minimumDateTime: _minimumDateTime,
                      maximumDateTime: _maximumDateTime,
                      initialDateTime: _selectedDate ?? _now,
                      onDateTimeChanged: _onDateChanged,
                      minuteInterval: 10,
                      mode: CupertinoCalendarMode.date,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        _selectedDate != null
                            ? _formatDate(_selectedDate!)
                            : 'DD / MM / YYYY',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                          color: _selectedDate != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // Time Picker Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Time', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              InkWell(
                key: _timePickerKey,
                onTap: () {
                  final renderBox = _timePickerKey.currentContext
                      ?.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    showCupertinoTimePicker(
                      context,
                      widgetRenderBox: renderBox,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                      onTimeChanged: _onTimeChanged,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        _selectedTime?.format(context) ?? 'HH:MM',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                          color: _selectedTime != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}