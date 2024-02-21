import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/widget_utils.dart';

class DateTimeTextFieldWidget extends StatefulWidget {
  const DateTimeTextFieldWidget({super.key, this.controller});

  final TextEditingController? controller;

  @override
  State<DateTimeTextFieldWidget> createState() =>
      _DateTimeTextFieldWidgetState();
}

class _DateTimeTextFieldWidgetState extends State<DateTimeTextFieldWidget> {
  DateTime date = DateTime.now();

  //format date to be just date
  // I want to format Like this: Friday, 8 Nov 2023
  String get dateFormatted => DateFormat('EEEE, d MMM y').format(date);
  @override
  void initState() {
    widget.controller?.text = dateFormatted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      controller: widget.controller,
      style: context.textTheme.bodyMedium,
      readOnly: true,
      decoration: WidgetUtils.getDecorations(Icons.calendar_month),
      onTap: () {
        _showDialog(
          CupertinoDatePicker(
            initialDateTime: date,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            // This shows day of week alongside day of month
            showDayOfWeek: true,
            // This is called when the user changes the date.
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                date = newDate;
                widget.controller?.text = dateFormatted;
              });
            },
          ),
        );
      },
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
