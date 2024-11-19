import 'dart:async';

import 'package:on_stage_app/app/device/application/device_service.dart';
import 'package:on_stage_app/app/enums/socket_event_type.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'socket_io_service.g.dart';

@Riverpod(keepAlive: true)
class SocketIoService extends _$SocketIoService {
  io.Socket? _socket;
  String? _currentDeviceId;

  io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  @override
  void build() {
    ref.listen(userNotifierProvider, (previous, next) async {
      final userId = next.currentUser?.id;
      if (userId == null) {
        _disconnect();
        return;
      }

      final deviceId = await ref.read(deviceServiceProvider).getDeviceId();
      if (_currentDeviceId == null) {
        if (_socket != null) {
          _disconnect();
        }
        _connect(deviceId);
      } else if (!isConnected) {
        logger.i('Reconnecting existing deviceId: $deviceId');
        _socket?.connect();
      }
    });
    return;
  }

  void _connect(String deviceId) {
    try {
      logger.i('Initializing socket for new user with device ID: $deviceId');

      _socket?.clearListeners();

      _socket = io.io(
        API.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setTimeout(5000)
            .setReconnectionDelay(5000)
            .setReconnectionDelayMax(10000)
            .setQuery({
              'deviceId': deviceId,
            })
            .setReconnectionAttempts(25)
            .build(),
      );

      _setupSocketListeners();
      _currentDeviceId = deviceId;
      _socket?.connect();
    } catch (e) {
      logger.e('Socket initialization error: $e');
      _currentDeviceId = null;
      _socket = null;
    }
  }

  void _setupSocketListeners() {
    if (_socket == null) return;

    _socket?.off('connect');
    _socket?.off('disconnect');
    _socket?.off('connect_error');
    _socket?.off('error');
    _socket?.off(SocketEventType.NOTIFICATION.name);

    _socket?.onConnect((_) {
      logger.i('Socket connected for user: $_currentDeviceId');
    });

    _socket?.onDisconnect((_) {
      logger.i('Socket disconnected for user: $_currentDeviceId');
    });

    _socket?.onConnectError((error) {
      logger.e('Connect error for user $_currentDeviceId: $error');
    });

    _socket?.onError((error) {
      logger.e('Socket error for user $_currentDeviceId: $error');
    });

    _listenOnNotifications();
    _listenOnSubscriptionUpdate();
  }

  void _listenOnNotifications() {
    _socket?.on(SocketEventType.NOTIFICATION.name, (data) {
      logger.i('Received notification event: $data');
      ref.read(notificationNotifierProvider.notifier)
        ..getNotifications()
        ..setHasNewNotifications(true);
    });
  }

  void _listenOnSubscriptionUpdate() {
    _socket?.on(SocketEventType.SUBSCRIPTION.name, (data) async {
      logger.i('Received SUBSCRIPTION event: $data');
      unawaited(
        Future.wait(
          [
            ref
                .read(subscriptionNotifierProvider.notifier)
                .getCurrentSubscription(forceUpdate: true),
            ref.read(teamNotifierProvider.notifier).getCurrentTeam(),
          ],
        ),
      );
    });

    _socket?.on(SocketEventType.TEAM_CHANGED.name, (data) async {
      logger.i('Received TEAM_CHANGED event: $data');
      ref.read(navigationNotifierProvider.notifier).resetRouterAndState();
    });
  }

  void _disconnect() {
    if (_socket != null) {
      logger.i('Disconnecting socket for user: $_currentDeviceId');
      _socket?.clearListeners();
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
      _currentDeviceId = null;
    }
  }

  void dispose() {
    _disconnect();
  }
}
