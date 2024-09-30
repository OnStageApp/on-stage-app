enum Position {
  leadVoice,
  altoVoice,
  tenorVoice,
  backingVoice,
  bass,
  drums,
  keyboard,
  other,
  acGuitar,
}

extension PositionX on Position {
  String get title {
    switch (this) {
      case Position.leadVoice:
        return 'Lead Voice';
      case Position.altoVoice:
        return 'Alto Voice';
      case Position.tenorVoice:
        return 'Tenor Voice';
      case Position.backingVoice:
        return 'Backing Voice';
      case Position.bass:
        return 'Bass Guitar';
      case Position.drums:
        return 'Drums';
      case Position.keyboard:
        return 'Keyboard';
      case Position.other:
        return 'Other';
      case Position.acGuitar:
        return 'Ac. Guitar';
    }
  }
}
