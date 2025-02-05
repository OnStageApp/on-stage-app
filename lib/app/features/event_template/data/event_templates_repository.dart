import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'event_templates_repository.g.dart';

@RestApi()
abstract class EventTemplatesRepository {
  factory EventTemplatesRepository(Dio dio) = _EventTemplatesRepository;

  @GET(API.getEventTemplates)
  Future<List<EventTemplate>> getEventTemplates();
}

final eventTemplatesRepoProvider = Provider<EventTemplatesRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EventTemplatesRepository(dio);
});
