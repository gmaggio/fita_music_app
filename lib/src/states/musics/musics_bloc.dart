import 'package:fita_music_app/src/ui/screens/musics/data/load_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'package:fita_music_app/src/data/models/music_data.dart';
import 'package:fita_music_app/src/data/repositories/musics_repository.dart';

part 'musics_event.dart';
part 'musics_selector.dart';
part 'musics_state.dart';

class MusicsBloc extends Bloc<MusicsEvent, MusicsState> {
  final MusicsRepository musicRepository;
  final AudioPlayer audioPlayer;

  MusicsBloc({
    required this.musicRepository,
    required this.audioPlayer,
  }) : super(const MusicsState.initial()) {
    on<MusicsInit>(_onInit);
    on<MusicsSearchInputChanged>(_onSearchInputChanged);
    on<MusicsExecuteSearch>(_onExecuteSearch);
    on<MusicsSelectSong>(_onSelectSong);
  }

  void _onInit(MusicsInit event, Emitter<MusicsState> emit) async {
    emit(const MusicsState.initial());
    return;
  }

  void _onSearchInputChanged(
      MusicsSearchInputChanged event, Emitter<MusicsState> emit) async {
    emit(state.asSearchInput(event.keywords));
    return;
  }

  void _onExecuteSearch(
      MusicsExecuteSearch event, Emitter<MusicsState> emit) async {
    try {
      emit(state.asMusicSearching());

      final List<MusicData> musics = await musicRepository.searchMusics(
        term: event.keywords,
        entity: 'musicTrack',
        attribute: 'artistTerm',
      );

      emit(state.asMusicsFound(musics));
    } on Exception catch (e) {
      debugPrint('Error: $e');
      emit(state.asMusicSearchError());
    }
  }

  void _onSelectSong(MusicsSelectSong event, Emitter<MusicsState> emit) async {
    emit(state.asMusicSelected(event.music));

    bool isAudioError = false;

    await audioPlayer
        .setAudioSource(
      AudioSource.uri(
        Uri.parse(event.music.previewUrl),
      ),
      preload: true,
    )
        .catchError(
      (error) {
        isAudioError = true;
        audioPlayer.stop();
        debugPrint('Exception: $error');
      },
    );

    if (isAudioError) {
      emit(state.asMusicError());
    } else {
      await audioPlayer.play();
    }
  }
}
