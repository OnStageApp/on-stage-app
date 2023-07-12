import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class InitSearch extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class SearchSongs extends SearchEvent {
  const SearchSongs({
    this.searchedText,
  });

  final String? searchedText;
  @override
  List<Object?> get props => [searchedText];
}

class ResetSearch extends SearchEvent {
  @override
  List<Object?> get props => [];
}
