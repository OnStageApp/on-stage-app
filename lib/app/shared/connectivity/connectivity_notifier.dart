import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_notifier.g.dart';

@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  @override
  bool build() {
    _initConnectivity();
    return true; // Assume connected initially
  }

  void _initConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      state = result.isNotEmpty &&
          result.any((status) => status != ConnectivityResult.none);
    });
  }

  void checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    state = result.isNotEmpty &&
        result.any((status) => status != ConnectivityResult.none);
  }
}
