import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/widget_utils.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

class AddEventScreenState extends ConsumerState<AddEventScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController executorController =
      TextEditingController(text: 'El Shaddai');
  TextEditingController beneficiaryController = TextEditingController();
  TextEditingController objectiveController = TextEditingController();
  DateTime date = DateTime.now();
  DateTime rehearsalDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: context.colorScheme.primary,
        ),
        onPressed: _submitForm,
        child: Text(
          'Submit',
          style: context.textTheme.titleSmall!.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      appBar: const StageAppBar(
        isBackButtonVisible: true,
        title: 'New Event',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            _buildTextField(
              context,
              'Title',
              Icons.church,
              objectiveController,
            ),
            const SizedBox(height: Insets.small),
            Text(
              'Date',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: Insets.small),
            DateTimeTextFieldWidget(controller: dateController),
            const SizedBox(height: Insets.small),
            _buildTextField(
              context,
              'Location',
              Icons.location_on,
              executorController,
              enabled: false,
            ),
            const SizedBox(height: Insets.small),
            Text(
              'Rehearal Date',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: Insets.small),
            DateTimeTextFieldWidget(controller: dateController),
            const SizedBox(height: Insets.small),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    IconData icon,
    TextEditingController controller, {
    bool? enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: Insets.small),
        TextField(
          enabled: enabled ?? true,
          style: context.textTheme.bodySmall,
          controller: controller,
          decoration: WidgetUtils.getDecorations(icon),
        ),
      ],
    );
  }

  void _submitForm() {
    // ref.read(offerNotifierProvider.notifier).createOffer(event);
  }
}
