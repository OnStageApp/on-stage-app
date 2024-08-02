import 'package:on_stage_app/app/features/event/application/event_items/event_items_state.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_items_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventItemsNotifier extends _$EventItemsNotifier {
  @override
  EventItemsState build() {
    return const EventItemsState();
  }

  Future<void> init() async {
    logger.i('init event provider state');
  }

  List<String> getStructureItems() {
    return List.of(
      ['None', 'Prayer Time', 'Worship', 'Message', 'Testimony'],
    );
  }
}
