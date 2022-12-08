part of 'musics_bloc.dart';

class MusicsStateSelector<T> extends BlocSelector<MusicsBloc, MusicsState, T> {
  MusicsStateSelector({
    super.key,
    required T Function(MusicsState) selector,
    required Widget Function(T) builder,
  }) : super(
          selector: selector,
          builder: (_, value) => builder(value),
        );
}

class MusicsSearchInputChangedSelector extends MusicsStateSelector<String> {
  MusicsSearchInputChangedSelector({
    super.key,
    required Widget Function(String searchKeyword) builder,
  }) : super(
          selector: (state) => state.searchKeyword,
          builder: builder,
        );
}

class MusicsSearchingSelector extends MusicsStateSelector<LoadStatus> {
  MusicsSearchingSelector({
    super.key,
    required Widget Function(LoadStatus searchStatus) builder,
  }) : super(
          selector: (state) => state.searchStatus,
          builder: builder,
        );
}

class MusicsListSelector extends MusicsStateSelector<List<MusicData>?> {
  MusicsListSelector({
    super.key,
    required Widget Function(List<MusicData>? musics) builder,
  }) : super(
          selector: (state) => state.musics,
          builder: builder,
        );
}

class MusicsSelectedSelector extends MusicsStateSelector<MusicData?> {
  MusicsSelectedSelector({
    super.key,
    required Widget Function(MusicData? music) builder,
  }) : super(
          selector: (state) => state.musicSelected,
          builder: builder,
        );
}

class MusicsErrorSelector extends MusicsStateSelector<bool> {
  MusicsErrorSelector({
    super.key,
    required Widget Function(bool isAudioError) builder,
  }) : super(
          selector: (state) => state.isAudioError,
          builder: builder,
        );
}
