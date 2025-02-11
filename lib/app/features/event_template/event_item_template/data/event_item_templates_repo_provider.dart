import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/data/event_item_templates_repo.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_item_templates_repo_provider.g.dart';

@riverpod
EventItemTemplatesRepo eventItemTemplatesRepo(Ref ref) {
  final dio = ref.watch(dioProvider);
  return EventItemTemplatesRepo(dio);
}
