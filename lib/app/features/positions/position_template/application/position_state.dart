import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/positions/position_template/domain/positiononst factory PositionState({
    @Default([]) List<Position> positions,
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _PositionState;
}
