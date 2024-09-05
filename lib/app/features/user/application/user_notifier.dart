import 'dart:async';

import 'package:on_stage_app/app/features/user/application/user_state.dart';
import 'package:on_stage_app/app/features/user/data/user_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  late final UserRepository _usersRepository;

  @override
  UserState build() {
    final dio = ref.read(dioProvider);
    _usersRepository = UserRepository(dio);
    return const UserState();
  }

  Future<void> init() async {
    logger.i('init user provider state');
  }

  Future<void> getAllUsers() async {
    state = state.copyWith(isLoading: true);
    final users = await _usersRepository.getUsers();
    state = state.copyWith(users: users, isLoading: false);
  }

  Future<void> getUninvitedUsersByEventId(String eventId) async {
    state = state.copyWith(isLoading: true);
    try {
      final users = await _usersRepository.getUninvitedUsersByEventId(eventId);
      state = state.copyWith(uninvitedUsers: users);
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
