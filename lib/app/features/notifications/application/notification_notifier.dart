import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_notifier.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier_state.dart';
import 'package:on_stage_app/app/features/notifications/data/notification_repository.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/data/user_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_notifier.g.dart';

const offset = 0;
const limit = 30;

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  NotificationRepository? _notificationRepository;
  UserRepository? _usersRepository;

  NotificationRepository get notificationRepository {
    _notificationRepository ??= NotificationRepository(ref.watch(dioProvider));
    return _notificationRepository!;
  }

  UserRepository get usersRepository {
    _usersRepository ??= UserRepository(ref.watch(dioProvider));
    return _usersRepository!;
  }

  @override
  NotificationNotifierState build() {
    logger.i('NotificationNotifier building');
    return const NotificationNotifierState();
  }

  Future<void> getNotifications() async {
    print('Getting notifications');
    await _fetchNotifications(offset: 0, append: false);
    _checkIfHaveNewNotifications();
  }

  Future<void> loadMoreNotifications() async {
    await _fetchNotifications(offset: state.notifications.length, append: true);
  }

  Future<void> _fetchNotifications({
    required int offset,
    required bool append,
  }) async {
    try {
      final userId = ref.read(userNotifierProvider).currentUser?.id;
      if (userId == null) return;

      final newNotifications =
          await notificationRepository.getNotifications(offset, limit);

      final notificationsWithPhotos = await Future.wait(
        newNotifications.notifications.map((notification) async {
          if (notification.params == null) return notification;
          if (notification.params!.usersWithPhoto.isNullOrEmpty) {
            return notification;
          }
          final photos = <Uint8List>[];
          for (final userId in notification.params!.usersWithPhoto!) {
            final photo = await _getPhotoBytes(userId);
            if (photo != null) {
              photos.add(photo);
            }
          }

          return notification = notification.copyWith(profilePictures: photos);
        }),
      );
      state = state.copyWith(
        notifications: append
            ? state.notifications + notificationsWithPhotos
            : notificationsWithPhotos,
        hasMoreNotifications: newNotifications.hasMore ?? false,
      );
    } catch (e, s) {
      logger.e('Error fetching notifications: $e $s');
    }
  }

  Future<void> markNotificationsAsViewed() async {
    try {
      await notificationRepository.markAsViewed();
      setHasNewNotifications(hasNewNotifications: false);
    } catch (e, s) {
      logger.e('Error updating notification: $e $s');
    }
  }

  Future<void> updateNotification(
    String notificationId,
    NotificationStatus status,
    NotificationActionStatus actionStatus,
  ) async {
    try {
      state = state.copyWith(
        notifications: state.notifications.map((notification) {
          return notification.notificationId == notificationId
              ? notification.copyWith(
                  status: status,
                  actionStatus: actionStatus,
                )
              : notification;
        }).toList(),
      );

      await notificationRepository.updateNotification(
        notificationId,
        state.notifications.firstWhere(
          (notification) => notification.notificationId == notificationId,
        ),
      );
    } catch (e, s) {
      logger.e('Error updating notification: $e $s');
    }
  }

  void setHasNewNotifications({required bool hasNewNotifications}) {
    logger.i('Setting hasNewNotifications to $hasNewNotifications');
    state = state.copyWith(hasNewNotifications: hasNewNotifications);
  }

  Future<Uint8List?> _getPhotoBytes(String userId) async {
    final localPhoto = await _getPhotoFromLocalStorage(userId);
    if (localPhoto != null) {
      logger.i('Loaded user photo from local storage ${DateTime.now()}');
      return localPhoto;
    }

    final photoUrl = await usersRepository.getPhotoByUserId(userId);

    if (photoUrl.isEmpty) {
      logger.i('Photo URL is empty');
      return null;
    }

    final photoBytes = await ref
        .read(amazonS3NotifierProvider.notifier)
        .getPhotoFromAWS(photoUrl);
    unawaited(_savePhotoToLocalStorage(userId, photoBytes!));
    return photoBytes;
  }

  Future<Uint8List?> _getPhotoFromLocalStorage(String userId) async {
    final photo =
        await ref.read(databaseProvider).getUserProfilePicture(userId);
    return photo;
  }

  Future<void> _savePhotoToLocalStorage(String userId, Uint8List photo) async {
    await ref.read(databaseProvider).updateUserProfilePicture(userId, photo);
  }

  void _checkIfHaveNewNotifications() {
    final hasNewNotifications = state.notifications
        .where((element) => element.status == NotificationStatus.NEW)
        .isNotEmpty;
    if (hasNewNotifications) {
      setHasNewNotifications(hasNewNotifications: true);
    } else {
      setHasNewNotifications(hasNewNotifications: false);
    }
  }
}
