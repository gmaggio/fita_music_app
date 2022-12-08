part of 'musics_bloc.dart';

class MusicsState {
  /// Stores the search keywords from the searchbar.
  final String searchKeyword;

  /// The list of musics data.
  final List<MusicData>? musics;

  /// The currently active music.
  final MusicData? musicSelected;

  /// Detects the status of the data being loaded.
  final LoadStatus searchStatus;

  /// checks the music player for error.
  final bool isAudioError;

  const MusicsState._({
    this.searchKeyword = '',
    this.musics,
    this.musicSelected,
    this.searchStatus = LoadStatus.initial,
    this.isAudioError = false,
  });

  const MusicsState.initial() : this._();

  //
  // States Managers
  //

  MusicsState asSearchInput(String text) {
    return copyWith(searchKeyword: text);
  }

  MusicsState asMusicSearching() {
    return copyWith(
      searchStatus: LoadStatus.loading,
    );
  }

  MusicsState asMusicSearchError() {
    return copyWith(
      searchStatus: LoadStatus.error,
    );
  }

  MusicsState asMusicsFound(List<MusicData>? musicsFound) {
    return copyWith(
      searchStatus: LoadStatus.loaded,
      musics: musicsFound,
    );
  }

  MusicsState asMusicSelected(MusicData musicSelected) {
    return copyWith(
      musicSelected: musicSelected,
      isAudioError: false,
    );
  }

  MusicsState asMusicError() {
    return copyWith(isAudioError: true);
  }

  //
  // Utilities
  //

  MusicsState copyWith({
    String? searchKeyword,
    List<MusicData>? musics,
    MusicData? musicSelected,
    LoadStatus? searchStatus,
    bool? isAudioError,
  }) {
    return MusicsState._(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      musics: musics ?? this.musics,
      musicSelected: musicSelected ?? this.musicSelected,
      searchStatus: searchStatus ?? this.searchStatus,
      isAudioError: isAudioError ?? this.isAudioError,
    );
  }
}
