import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'web_socket_service.g.dart';

@Riverpod(keepAlive: true)
class WebSocketService extends _$WebSocketService {
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  @override
  void build() {
    _initialize();
    return;
  }

  void _initialize() {
    try {
      logger.i('Initializing socket');
      _socket = io.io(
        API.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setTimeout(5000)
            .setReconnectionDelay(1000)
            .setReconnectionAttempts(5)
            .build(),
      );

      _setupSocketListeners();
      _socket?.connect();
    } catch (e) {
      logger.e('Socket initialization error: $e');
    }
  }

  void _setupSocketListeners() {
    _socket?.onConnect((_) {
      logger.i('Socket connected');
    });

    _socket?.onDisconnect((_) {
      logger.i('Socket disconnected');
    });

    _socket?.onConnectError((error) {
      logger.e('Connect error: $error');
    });

    _socket?.onError((error) {
      logger.e('Socket error: $error');
    });
  }

// Core methods for other notifiers to use
  void emit(String event, dynamic data) {
    if (_socket?.connected ?? false) {
      _socket?.emit(event, data);
      logger.i('Emitted $event event with data: $data');
    } else {
      logger.w('Socket is not connected. Cannot emit event: $event');
    }
  }

  void on(String event, void Function(dynamic) callback) {
    _socket?.on(event, callback);
    logger.i('Added listener for event: $event');
  }

  void off(String event) {
    _socket?.off(event);
    logger.i('Removed listener for event: $event');
  }

  bool get isConnected => _socket?.connected ?? false;
}
