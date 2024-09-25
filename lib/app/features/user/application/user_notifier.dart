import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_state.dart';
import 'package:on_stage_app/app/features/user/data/profile_picture_repository.dart';
import 'package:on_stage_app/app/features/user/data/user_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  UserRepository? _usersRepository;

  UserRepository get usersRepository {
    _usersRepository ??= UserRepository(ref.read(dioProvider));
    return _usersRepository!;
  }

  @override
  UserState build() {
    ref.onDispose(() {
      logger.i('UserNotifier disposed');
    });
    return const UserState();
  }

  Future<void> getCurrentUser() async {
    if (state.currentUser != null) return;
    state = state.copyWith(isLoading: true);
    final currentUser = await usersRepository.getCurrentUser();
    state = state.copyWith(currentUser: currentUser, isLoading: false);
  }

  Future<void> init() async {
    logger.i('init user provider state');
    await getCurrentUser();
    await saveAndGetUserPhoto(forceUpdate: true);
  }

  Future<void> getAllUsers() async {
    if (state.users.isNotNullOrEmpty) return;
    state = state.copyWith(isLoading: true);
    final users = await usersRepository.getUsers();
    state = state.copyWith(users: users, isLoading: false);
  }

  Future<void> uploadPhoto(File image) async {
    final profilePictureRepo = ProfilePictureRepository(ref.read(dioProvider));
    try {
      await profilePictureRepo.updateUserImage(image);
      await saveAndGetUserPhoto(forceUpdate: true);
    } catch (e) {
      logger.e('Error uploading photo: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }

  Future<void> saveAndGetUserPhoto({bool forceUpdate = false}) async {
    logger
        .i('Fetching user photo ${DateTime.now()}, forceUpdate: $forceUpdate');
    try {
      if (!forceUpdate && state.userPhoto != null) {
        logger.i('Using cached user photo');
        return;
      }

      if (!forceUpdate) {
        final localPhoto = await _getPhotoFromLocalStorage();
        if (localPhoto != null) {
          state = state.copyWith(userPhoto: localPhoto);
          logger.i('Loaded user photo from local storage ${DateTime.now()}');
          return;
        }
      }

      final photoUrl = await usersRepository.getUserPhotoUrl();

      if (photoUrl.isNotEmpty) {
        final photoBytes = await ref
            .read(amazonS3NotifierProvider.notifier)
            .getPhotoFromAWS(photoUrl);

        if (photoBytes != null) {
          state = state.copyWith(userPhoto: photoBytes);
          await _savePhotoToLocalStorage(photoBytes);
          logger.i('Done fetching and saving user photo ${DateTime.now()}');
        } else {
          logger.e('Failed to fetch photo. Response is empty.');
        }
      } else {
        logger.i('Photo URL is empty');
      }
    } catch (e) {
      logger.e('Error fetching user photo: $e');
    }
  }

  Future<Uint8List?> _getPhotoFromLocalStorage() async {
    final photo = await ref
        .read(databaseProvider)
        .getUserProfilePicture(state.currentUser?.id ?? '');
    return photo;
  }

  Future<void> _savePhotoToLocalStorage(Uint8List photo) async {
    await ref
        .read(databaseProvider)
        .updateUserProfilePicture(state.currentUser?.id ?? '', photo);
  }
}
