import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/web_socket/web_socket_service.dart';

class WebSocketNotifier extends StateNotifier<List<String>> {
  WebSocketNotifier() : super([]);

  final WebSocketService _service = WebSocketService();

  void connect(String url) {
    try {
      _service.connect(url);
      _service.stream.listen(
        (message) {
          state = [...state, message.toString()];
        },
        onError: (error) {
          state = [...state, 'Error receiving message: $error'];
          // You might want to attempt reconnection here
          _attemptReconnection(url);
        },
        onDone: () {
          state = [...state, 'WebSocket connection closed'];
          // You might want to attempt reconnection here as well
          _attemptReconnection(url);
        },
      );
    } catch (e) {
      state = [...state, 'Failed to connect: $e'];
      // Attempt to reconnect after a delay
      _attemptReconnection(url);
    }
  }

  void sendMessage(String message) {
    try {
      _service.sendMessage(message);
    } catch (e) {
      state = [...state, 'Failed to send message: $e'];
    }
  }

  void disconnect() {
    try {
      _service.disconnect();
    } catch (e) {
      state = [...state, 'Error during disconnect: $e'];
    }
  }

  void _attemptReconnection(String url) {
    Future.delayed(const Duration(seconds: 5), () {
      state = [...state, 'Attempting to reconnect...'];
      connect(url);
    });
  }
}

final webSocketProvider =
    StateNotifierProvider<WebSocketNotifier, List<String>>((ref) {
  return WebSocketNotifier();
});
