import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class NotificationRepository {
  factory NotificationRepository(Dio dio, {String baseUrl}) = _NotificationRepository;

  // @GET("/notifications/unread")
  // Future<List<StageNotification>> getUnreadNotifications();
  //
  // @GET("/notifications/last-seven-days")
  // Future<List<StageNotification>> getLastSevenDaysNotifications();
  //
  // @GET("/notifications/last-thirty-days")
  // Future<List<StageNotification>> getLastThirtyDays();
}