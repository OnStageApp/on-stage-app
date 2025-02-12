import 'dart:async';

import 'package:on_stage_app/app/features/event_template/event_item_template/application/event_item_templates_state.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/data/event_item_templates_repo.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/data/event_item_templates_repo_provider.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template_create.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/update_event_item_template_index.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_item_templates_notifier.g.dart';

@Riverpod()
class EventItemTemplatesNotifier extends _$EventItemTemplatesNotifier {
  EventItemTemplatesRepo get _eventItemTemplatesRepo =>
      ref.read(eventItemTemplatesRepoProvider);

  @override
  EventItemTemplatesState build() {
    logger.i('Event Items Notifier rebuild');
    return const EventItemTemplatesState();
  }

  Future<void> getEventItemTemplates(String eventTemplateId) async {
    state = state.copyWith(isLoading: true);

    final eventItemTemplates =
        await _eventItemTemplatesRepo.getEventItems(eventTemplateId);

    state = state.copyWith(
      eventItemTemplates: eventItemTemplates,
    );

    state = state.copyWith(isLoading: false);
  }

  Future<void> addEventItemTemplate(
    EventItemTemplateCreate eventItemTemplateCreate,
  ) async {
    state = state.copyWith(isLoading: true);

    final eventItemTemplateCreateRequest = eventItemTemplateCreate.copyWith(
      index: state.eventItemTemplates.length,
    );

    final updatedEventItem =
        await _eventItemTemplatesRepo.addMoment(eventItemTemplateCreateRequest);

    state = state.copyWith(
      isLoading: false,
      eventItemTemplates: [...state.eventItemTemplates, updatedEventItem],
    );
  }

  Future<void> updateEventItemTemplate(
    EventItemTemplate eventItemTemplateCreate,
  ) async {
    state = state.copyWith(isLoading: true);

    final updatedEventItemTemplateCreate = eventItemTemplateCreate;

    final updatedEventItem = await _eventItemTemplatesRepo.updateEventItem(
      updatedEventItemTemplateCreate.id,
      updatedEventItemTemplateCreate,
    );

    final updatedItems = state.eventItemTemplates
        .map((item) => item.id == updatedEventItem.id ? updatedEventItem : item)
        .toList();

    state = state.copyWith(
      isLoading: false,
      eventItemTemplates: updatedItems,
    );
  }

  Future<void> updateEventItemTemplatesIndexes() async {
    final eventItemTemplates = state.eventItemTemplates;

    try {
      final updatedEventItemTemplates = eventItemTemplates
          .map((e) {
            if (e.index != null) {
              return UpdateEventItemTemplateIndex(
                eventItemTemplateId: e.id,
                index: e.index!,
              );
            }
            return null;
          })
          .whereType<UpdateEventItemTemplateIndex>()
          .toList();

      await _eventItemTemplatesRepo
          .updateEventItemTemplateIndexes(updatedEventItemTemplates);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEventItem(String eventItemTemplateId) async {
    final deletedItemIndex = state.eventItemTemplates
        .indexWhere((item) => item.id == eventItemTemplateId);
    if (deletedItemIndex == -1) return;

    final originalItems = [...state.eventItemTemplates];
    final updatedItems = _getUpdatedItemsAfterDeletion(deletedItemIndex);

    state = state.copyWith(eventItemTemplates: updatedItems);

    try {
      await _eventItemTemplatesRepo
          .deleteEventItemTemplate(eventItemTemplateId);

      final updateRequests = updatedItems
          .where((item) => item.index != null)
          .map(
            (item) => UpdateEventItemTemplateIndex(
              eventItemTemplateId: item.id,
              index: item.index!,
            ),
          )
          .toList();

      if (updateRequests.isNotEmpty) {
        await _eventItemTemplatesRepo
            .updateEventItemTemplateIndexes(updateRequests);
      }
    } catch (e) {
      state = state.copyWith(eventItemTemplates: originalItems);
      rethrow;
    }
  }

  List<EventItemTemplate> _getUpdatedItemsAfterDeletion(int deletedIndex) {
    return state.eventItemTemplates
        .where((item) => item.id != state.eventItemTemplates[deletedIndex].id)
        .map((item) {
      if (item.index != null && item.index! > deletedIndex) {
        return item.copyWith(index: item.index! - 1);
      }
      return item;
    }).toList();
  }

  void changeOrderCache(int oldIndex, int newIndex) {
    final items = state.eventItemTemplates.toList();
    final item = items.removeAt(oldIndex);

    final adjustedNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;

    items.insert(adjustedNewIndex, item);
    final reorderAllEvents = _reorderAllEvents(items);
    state = state.copyWith(eventItemTemplates: reorderAllEvents);
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  List<EventItemTemplate> _reorderAllEvents(List<EventItemTemplate> items) {
    final reorderAllEvents = items.map((e) {
      return e.copyWith(index: items.indexOf(e));
    }).toList();
    return reorderAllEvents;
  }
}
