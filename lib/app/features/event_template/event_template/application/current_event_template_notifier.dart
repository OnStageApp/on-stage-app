import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/current_event_template_state.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/event_templates_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/data/event_templates_repository.dart';
import 'package:on_stage_app/app/features/event_template/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/event_template/event_template/domain/event_template_request.dart';
import 'package:on_stage_app/app/features/stager_template/domain/stager_template.dart';
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

  Future<void> updateEventTemplate(EventTemplateRequest template) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final templateId = template.id;
      if (templateId == null) return;
      final updatedTemplate = await _repository.updateEventTemplate(
        templateId,
        template,
      );
      state = state.copyWith(eventTemplate: updatedTemplate, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
      rethrow;
    }
  }

  Future<void> deleteEventTemplate(String templateId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteEventTemplate(templateId);
      ref
          .read(eventTemplatesNotifierProvider.notifier)
          .removeEventTemplate(templateId);
          
      state = state.copyWith(eventTemplate: null, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
      rethrow;
    }
  }

  Future<void> getStagersByGroupAndEventTemplate({
    required String eventTemplateId,
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final stagers = await _repository.getStagersByGroupAndEvent(
        eventTemplateId: eventTemplateId,
        groupId: groupId,
      );
      final stagersWithPhoto =
          await Future.wait<StagerTemplate>(stagers.map(_getStagerWithPhoto));
      state =
          state.copyWith(stagerTemplates: stagersWithPhoto, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<StagerTemplate> _getStagerWithPhoto(
    StagerTemplate stager,
  ) async {
    final photo = await _setPhotosFromLocalStorage(stager.userId);
    return stager.copyWith(profilePicture: photo);
  }

  Future<Uint8List?> _setPhotosFromLocalStorage(
    String? userId,
  ) async {
    if (userId == null) return null;
    final photo = await ref.read(databaseProvider).getTeamMemberPhoto(userId);
    return photo?.profilePicture;
  }
}
