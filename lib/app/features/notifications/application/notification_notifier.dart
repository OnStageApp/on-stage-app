import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_notifier.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  @override
  List<StageNotification> build() {
    return [];
  }

  Future<void> getNotifications() async {
    state = SongDummy.notificationsDummy;
  }
}
