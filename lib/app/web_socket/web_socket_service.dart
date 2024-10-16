import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

part 'web_socket_service.g.dart';

class WebSocketService {
  StompClient? _client;
  final Map<String, void Function(String)> _subscriptions = {};

  Future<void> connect() async {
    if (_client != null && (_client?.connected ?? false)) {
      logger.i('Already connected to WebSocket. Skipping new connection.');
      return;
    }

    const storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'token');

    if (authToken == null) {
      logger.e('No auth token found');
      return;
    }

    _client = StompClient(
      config: StompConfig(
        url: 'wss://dev.on-stage.app/${API.wsBaseUrl}',
        onConnect: _onConnect,
        beforeConnect: () async {
          logger.i('Connecting to WebSocket...');
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onStompError: (frame) => logger.e('STOMP error: ${frame.body}'),
        onWebSocketError: (error) => logger.e('WebSocket error: $error'),
        onDisconnect: (_) {
          logger.i('WebSocket disconnected');
          _client = null;
        },
        stompConnectHeaders: {'Authorization': 'Bearer $authToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $authToken'},
      ),
    );

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    logger.i('Connected to STOMP');
    _subscriptions.forEach(_subscribe);
  }

  void subscribe(String destination, void Function(String) onMessageReceived) {
    print('INIT SUBSCRIPTIONS: $_subscriptions');
    _subscriptions[destination] = onMessageReceived;
    print('Subscriptions: $_subscriptions');
    if (_client?.connected ?? false) {
      _subscribe(destination, onMessageReceived);
    }
  }

  void _subscribe(String destination, void Function(String) onMessageReceived) {
    _client!.subscribe(
      destination: destination,
      callback: (StompFrame frame) {
        if (frame.body != null) {
          onMessageReceived(frame.body!);
        }
      },
    );
  }

  void sendMessage(String destination, String message) {
    _client?.send(
      destination: destination,
      body: message,
    );
  }

  void unsubscribe(String destination) {
    _subscriptions.remove(destination);
  }

  void disconnect() {
    _client?.deactivate();
    _subscriptions.clear();
  }

  bool get isConnected => _client?.connected ?? false;
}

@Riverpod(keepAlive: true)
WebSocketService webSocketService(WebSocketServiceRef ref) {
  return WebSocketService();
}
