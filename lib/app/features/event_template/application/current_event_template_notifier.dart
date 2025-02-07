import 'package:on_stage_app/app/features/event_template/application/current_event_template_state.dart';
import 'package:on_stage_app/app/features/event_template/data/event_templates_repository.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template_request.dart';
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

  Future<EventTemplate> createEmptyEventTemplate() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedTemplate =
          await _repository.createEventTemplate(const EventTemplateRequest());
      state = state.copyWith(eventTemplate: savedTemplate, isLoading: false);
      return savedTemplate;
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
      rethrow;
    }
  }
}
