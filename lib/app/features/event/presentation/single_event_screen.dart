import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class SingleEventScreen extends ConsumerStatefulWidget {
  SingleEventScreen(this.event, {super.key});

  final EventModel event;

  @override
  SingleEventScreenState createState() => SingleEventScreenState();
}

class SingleEventScreenState extends ConsumerState<SingleEventScreen> {
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
        title: 'Events ${widget.event.name}',
        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            _buildCupertinoDatePicker('Date', (newDate) {
              setState(() => date = newDate);
            }),
            const SizedBox(height: 10),
            _buildCupertinoDatePicker('Rehearsal Date', (newDate) {
              setState(() => rehearsalDate = newDate);
            }),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Process form submission here
    var newEvent = widget.event.copyWith(
      name: titleController.text,
    );
    print('Title: ${titleController.text}');
    print('Date: $date');
    print('Rehearsal Date: $rehearsalDate');
    print('Location: ${locationController.text}');

    print('Old Event: ${widget.event.name}');
    print('New Event: ${newEvent.name}');

    ref
        .read(eventNotifierProvider.notifier)
        .updateEvent(widget.event, newEvent);
  }
}

Widget _buildCupertinoDatePicker(
  String label,
  ValueChanged<DateTime> onDateChanged,
) {
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
