import 'package:on_stage_app/app/features/event_template/application/event_templates_state.dart';
import 'package:on_stage_app/app/features/event_template/data/event_templates_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_templates_notifier.g.dart';

@riverpod
class EventTemplatesNotifier extends _$EventTemplatesNotifier {
  EventTemplatesRepository get _repository =>
      ref.read(eventTemplatesRepoProvider);

  @override
  EventTemplatesState build() {
    return const EventTemplatesState();
  }

  Future<void> getEventTemplates() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final eventTemplates = await _repository.getEventTemplates();
      state = state.copyWith(eventTemplates: eventTemplates);
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void removeEventTemplate(String eventTemplateId) {
    state = state.copyWith(
      eventTemplates: state.eventTemplates
          .where((eventTemplate) => eventTemplate.id != eventTemplateId)
          .toList(),
    );
  }
}
