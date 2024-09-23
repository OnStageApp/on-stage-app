import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_repository.dart';
import 'package:on_stage_app/app/features/user/application/user_state.dart';
import 'package:on_stage_app/app/features/user/data/profile_picture_repository.dart';
import 'package:on_stage_app/app/features/user/data/user_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/data/dio_s3_client/dio_s3_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  UserRepository? _usersRepository;
  late final AmazonS3Repository _amazonS3Repository;

  UserRepository get usersRepository {
    _usersRepository ??= UserRepository(ref.read(dioProvider));
    return _usersRepository!;
  }

  @override
  UserState build() {
    final dioS3 = ref.read(dioS3Provider);
    _amazonS3Repository = AmazonS3Repository(dioS3);
    return const UserState();
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(isLoading: true);
    // await _usersRepository
    //     .getUserById('9zNhTEXqVXdbXZoUczUtWK3OJq63')
    //     .then((user) {
    //   state = state.copyWith(currentUser: user, isLoading: false);
    // });
  }

  Future<void> init() async {
    logger.i('init user provider state');
  }

  Future<void> getAllUsers() async {
    state = state.copyWith(isLoading: true);
    final users = await usersRepository.getUsers();
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
          await usersRepository.getUserById(state.currentUser!.id);
      state = state.copyWith(currentUser: currentUser);
    } catch (e) {
      logger.e('error $e');
      // Handle error
    }
  }

  Future<void> getUserPhoto() async {
    logger.i('Fetching user photo ${DateTime.now()}');
    try {
      if (state.userPhoto != null) {
        return;
      }
      final photoUrl = await usersRepository.getUserPhotoUrl();

      if (photoUrl.isNotEmpty) {
        final photoBytes =
            await _amazonS3Repository.getUserPhotoFromS3(photoUrl);

        if (photoBytes.isNotEmpty) {
          state = state.copyWith(userPhoto: Uint8List.fromList(photoBytes));
        } else {
          logger.e('Failed to fetch photo. Response is empty.');
        }
        logger.i('Done fetching user photo ${DateTime.now()}');
      } else {
        logger.i('Photo URL is empty');
      }
    } catch (e) {
      logger.e('Error fetching user photo: $e');
    }
  }
}
