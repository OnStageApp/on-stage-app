import 'package:on_stage_app/app/features/event_template/application/current_event_template_state.dart';
import 'package:on_stage_app/app/features/event_template/data/event_templates_repository.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_event_template_notifier.g.dart';

@riverpod
class CurrentEventTemplate extends _$CurrentEventTemplate {
  EventTemplatesRepository get _repository =>
      ref.read(eventTemplatesRepoProvider);

  @override
  CurrentEventTemplateState build() {
    return const CurrentEventTemplateState();
  }

  Future<void> initialize(EventTemplate? template) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      state = state.copyWith(
        eventTemplate: template,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e,
        isLoading: false,
      );
    }
  }

  Future<void> save({
    required String name,
    required String location,
    List<int>? reminders,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final template = state.eventTemplate;
      final savedTemplate = template?.id == null
          ? await _repository.createEventTemplate(template!)
          : await _repository.updateEventTemplate(template!.id!, template);

      state = state.copyWith(
        eventTemplate: savedTemplate,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e,
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Add update, delete in the future
}
