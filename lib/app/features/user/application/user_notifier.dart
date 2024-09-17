import 'dart:async';
import 'dart:io';

import 'package:on_stage_app/app/features/user/application/user_state.dart';
import 'package:on_stage_app/app/features/user/data/profile_picture_repository.dart';
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

  Future<void> getCurrentUser() async {
    state = state.copyWith(isLoading: true);
    await _usersRepository
        .getUserById('9zNhTEXqVXdbXZoUczUtWK3OJq63')
        .then((user) {
      state = state.copyWith(currentUser: user, isLoading: false);
    });
  }

  Future<void> init() async {
    logger.i('init user provider state');
  }

  Future<void> getAllUsers() async {
    state = state.copyWith(isLoading: true);
    final users = await _usersRepository.getUsers();
    state = state.copyWith(users: users, isLoading: false);
  }

  Future<void> uploadPhoto(File image) async {
    final profilePictureRepo = ProfilePictureRepository(ref.read(dioProvider));
    try {
      await profilePictureRepo.updateUserImage(
        state.currentUser!.id,
        image,
      );
      final currentUser =
          await _usersRepository.getUserById(state.currentUser!.id);
      state = state.copyWith(currentUser: currentUser);
    } catch (e) {
      print('error $e');
      // Handle error
    }
  }
}
