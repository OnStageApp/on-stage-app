import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_provider.g.dart';

@Riverpod(keepAlive: true)
class Loading extends _$Loading {
  @override
  bool build() {
    return false;
  }

  void setLoading({required bool value}) {
    state = value;
    logger.i('Loading state: $value');
  }
}
