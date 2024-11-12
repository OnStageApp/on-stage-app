import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/analytics/analytics_service.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_notifier.dart';
import 'package:on_stage_app/app/features/login/domain/user_request.dart';
import 'package:on_stage_app/app/features/user/application/user_state.dart';
import 'package:on_stage_app/app/features/user/data/profile_picture_repository.dart';
import 'package:on_stage_app/app/features/user/data/user_repository.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
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
    state = state.copyWith(isLoading: true);
    final currentUser = await usersRepository.getCurrentUser();
    _setUserIdInAnalytics(currentUser.id, currentUser.name ?? '');
    state = state.copyWith(currentUser: currentUser, isLoading: false);
  }

  Future<void> editUserById(UserRequest userRequest) async {
    try {
      final userId = state.currentUser?.id;
      if (userId == null) return;
      state = state.copyWith(isLoading: true);
      final editedUser = await usersRepository.editUser(userRequest);
      final finalUser = state.currentUser!.copyWith(
        name: editedUser.name,
      );
      state = state.copyWith(currentUser: finalUser, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      logger.e('Error updating user: $e');
    }
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

    if (!forceUpdate && state.currentUser?.image != null) {
      logger.i('Using cached user photo');
      return;
    }

    try {
      final photoBytes = await _getPhotoBytes(forceUpdate);

      if (photoBytes != null) {
        state = state.copyWith(
            currentUser: state.currentUser?.copyWith(image: photoBytes));
        await _savePhotoToLocalStorage(photoBytes);
        logger.i('Done fetching and saving user photo ${DateTime.now()}');
      } else {
        state = state.copyWith(
          currentUser: state.currentUser?.copyWith(
            image: photoBytes,
          ),
        );
        logger.i('Photo not found');
      }
    } catch (e) {
      state = state.copyWith(
        currentUser: state.currentUser?.copyWith(image: null),
      );
      logger.e('Error fetching user photo: $e');
    }
  }

  Future<void> checkPermissions(PermissionType permission) async {
    final hasPermissions =
        await usersRepository.checkPermission(permission.name);
  }

  Future<Uint8List?> _getPhotoBytes(bool forceUpdate) async {
    if (!forceUpdate) {
      final localPhoto = await _getPhotoFromLocalStorage();
      if (localPhoto != null) {
        logger.i('Loaded user photo from local storage ${DateTime.now()}');
        return localPhoto;
      }
    }

    final photoUrl = await usersRepository.getUserPhotoUrl();

    if (photoUrl.isEmpty) {
      logger.i('Photo URL is empty');
      return null;
    }

    final photoBytes = await ref
        .read(amazonS3NotifierProvider.notifier)
        .getPhotoFromAWS(photoUrl);

    return photoBytes;
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

  void _setUserIdInAnalytics(String userId, String userName) {
    ref.read(analyticsServiceProvider.notifier).setUserId(
          userId,
        );
    ref.read(analyticsServiceProvider.notifier).setUserProperty(
          name: 'name',
          value: userName,
        );
  }

  Future<void> deleteAccount() {
    final id = state.currentUser?.id;
    return usersRepository.deleteUser(id ?? '');
  }
}
