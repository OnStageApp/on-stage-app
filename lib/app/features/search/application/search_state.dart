class SearchState {
  final bool isFocused;
  final String text;

  SearchState({
    required this.isFocused,
    required this.text,
  });

  SearchState copyWith({
    bool? isFocused,
    String? text,
  }) {
    return SearchState(
      isFocused: isFocused ?? this.isFocused,
      text: text ?? this.text,
    );
  }
}
