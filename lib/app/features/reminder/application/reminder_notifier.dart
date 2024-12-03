import 'package:on_stage_app/app/features/reminder/application/reminder_state.dart';
import 'package:on_stage_app/app/features/reminder/data/reminder_repository.dart';
import 'package:on_stage_app/app/features/reminder/domain/reminder_request.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_notifier.g.dart';

@riverpod
class ReminderNotifier extends _$ReminderNotifier {
  late final ReminderRepository _reminderRepository;

  @override
  ReminderState build() {
    final dio = ref.watch(dioProvider);
    _reminderRepository = ReminderRepository(dio);
    return const ReminderState();
  }

  Future<void> createReminders(
    List<int> daysBeforeEvent,
    String eventId,
  ) async {
    final mutableDaysBeforeEvent = List<int>.from(daysBeforeEvent)
      ..removeWhere((element) => element == 0);

    final request = ReminderRequest(
      daysBefore: mutableDaysBeforeEvent,
      eventId: eventId,
    );

    final allReminders = await _reminderRepository.addReminders(request);

    state = state.copyWith(reminders: allReminders);
  }

  Future<void> getReminders(String eventId) async {
    final reminders = await _reminderRepository.getReminders(eventId: eventId);
    state = state.copyWith(reminders: reminders);
  }
}
