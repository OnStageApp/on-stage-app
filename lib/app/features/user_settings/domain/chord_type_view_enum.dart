enum ChordViewPref {
  flat,
  sharp,
}

extension ChordTypeViewExtension on ChordViewPref {
  String get icon {
    switch (this) {
      case ChordViewPref.flat:
        return '♭';
      case ChordViewPref.sharp:
        return '♯';
    }
  }

  String get description {
    switch (this) {
      case ChordViewPref.flat:
        return 'Flat Chords';
      case ChordViewPref.sharp:
        return 'Sharp Chords';
    }
  }
}
