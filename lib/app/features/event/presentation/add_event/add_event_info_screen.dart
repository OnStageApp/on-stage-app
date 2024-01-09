import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/close_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddEventInfoScreen extends ConsumerStatefulWidget {
  const AddEventInfoScreen({super.key});

  @override
  AddEventInfoScreenState createState() => AddEventInfoScreenState();

  static void show(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: context.colorScheme.background,
      isScrollControlled: true,
      context: context,
      builder: (context) => NestedScrollModal(
        footerHeight: () => 59,
        buildContent: () => const AddEventInfoScreen(),
      ),
    );
  }
}

class AddEventInfoScreenState extends ConsumerState<AddEventInfoScreen> {
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
    return Container(
      height: MediaQuery.of(context).size.height - CloseHeader.height,
      padding: defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.popDialog(),
            child: Text(
              'Cancel',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(height: 32),
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
          const Expanded(child: SizedBox()),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ),
          const SizedBox(height: 32),
        ],
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
    context.pushNamed(AppRoute.addEventItems.name);
    // ref.read(eventNotifierProvider.notifier).addEvent(event);
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
