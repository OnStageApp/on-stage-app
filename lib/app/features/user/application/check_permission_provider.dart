import 'package:on_stage_app/app/features/user/data/user_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_permission_provider.g.dart';

@riverpod
class CheckPermission extends _$CheckPermission {
  @override
  Future<bool> build(String permission) async {
    final dio = ref.watch(dioProvider);
    final userRepository = UserRepository(dio);
    return userRepository.checkPermission(permission);
  }
}
