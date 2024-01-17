import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

class AddEventScreenState extends ConsumerState<AddEventScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime date = DateTime.now();
  DateTime rehearsalDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StageAppBar(
        title: 'Events',
        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            _buildCupertinoDatePicker('Date', (newDate) {
              setState(() => date = newDate);
            }),
            SizedBox(height: 10),
            _buildCupertinoDatePicker('Rehearsal Date', (newDate) {
              setState(() => rehearsalDate = newDate);
            }),
            SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Process form submission here
    print('Title: ${titleController.text}');
    print('Date: $date');
    print('Rehearsal Date: $rehearsalDate');
    print('Location: ${locationController.text}');

    final event = EventModel(
      id: '',
      name: titleController.text,
      date: date,
      rehearsalDates: [rehearsalDate],
      location: locationController.text,
      eventItems: [],
    );

    ref.read(eventNotifierProvider.notifier).addEvent(event);
  }
}

Widget _buildCupertinoDatePicker(
    String label, ValueChanged<DateTime> onDateChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      SizedBox(height: 5),
      Container(
        height: 100,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: onDateChanged,
        ),
      ),
    ],
  );
}
