import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/reminder/domain/reminder_model.dart';
import 'package:on_stage_app/app/features/reminder/domain/reminder_request.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'reminder_repository.g.dart';

@RestApi()
abstract class ReminderRepository {
  factory ReminderRepository(Dio dio) = _ReminderRepository;

  @GET(API.reminders)
  Future<List<Reminder>> getReminders({
    @Query('eventId') required String eventId,
  });

  @POST(API.reminders)
  Future<List<Reminder>> addReminders(
    @Body() ReminderRequest reminder,
  );
}
