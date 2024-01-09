import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class AddEventItemsScreen extends ConsumerStatefulWidget {
  const AddEventItemsScreen({super.key});

  @override
  AddEventItemsScreenState createState() => AddEventItemsScreenState();
}

class AddEventItemsScreenState extends ConsumerState<AddEventItemsScreen> {
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
        child: Column(
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
            Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
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
      staggersId: [],
      adminsId: [],
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
      const SizedBox(height: 5),
      SizedBox(
        height: 100,
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: onDateChanged,
        ),
      ),
    ],
  );
}
