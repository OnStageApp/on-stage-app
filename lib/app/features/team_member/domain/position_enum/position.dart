enum Position {
  leadVoice,
  altoVoice,
  tenorVoice,
  sopranoVoice,
  backingVoice,
  drums,
  keyboard,
  piano,
  synth,
  acGuitar,
  elGuitar,
  bassGuitar,
  violin,
  cello,
  other,
}

extension PositionX on Position {
  String get title {
    switch (this) {
      case Position.leadVoice:
        return 'Lead Voice';
      case Position.altoVoice:
        return 'Alto';
      case Position.tenorVoice:
        return 'Tenor';
      case Position.sopranoVoice:
        return 'Soprano';
      case Position.backingVoice:
        return 'Backing Vox';
      case Position.bassGuitar:
        return 'Bass Guitar';
      case Position.drums:
        return 'Drums';
      case Position.keyboard:
        return 'Keyboard';
      case Position.other:
        return 'Other';
      case Position.acGuitar:
        return 'Ac. Guitar';
      case Position.elGuitar:
        return 'El. Guitar';
      case Position.piano:
        return 'Piano';
      case Position.synth:
        return 'Synth';
      case Position.violin:
        return 'Violin';
      case Position.cello:
        return 'Cello';
    }
  }
}
