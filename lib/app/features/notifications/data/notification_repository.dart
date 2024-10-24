import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class NotificationRepository {
  factory NotificationRepository(Dio dio) = _NotificationRepository;

  @GET(API.wsNotifications)
  Future<List<StageNotification>> getNotifications(
    @Query('userId') String userId,
  );
}
