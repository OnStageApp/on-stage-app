import 'package:on_stage_app/app/features/lyrics/chord_transposer.dart';
import 'package:on_stage_app/app/features/song/application/preferences/preferences_state.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_notifier.g.dart';

@Riverpod(keepAlive: true)
class PreferencesNotifier extends _$PreferencesNotifier {
  @override
  PreferencesState build() => const PreferencesState();

  Future<void> init() async {}

  Future<void> setFontSize(TextSize textSizeEnum) async {
    state = state.copyWith(
      lyricsChordsSize: textSizeEnum,
    );
  }

  void setChordViewMode(ChordNotation viewModeEnum) {
    state = state.copyWith(
      chordViewMode: viewModeEnum,
    );
  }
}
