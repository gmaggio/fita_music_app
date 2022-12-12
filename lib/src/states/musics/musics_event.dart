part of 'musics_bloc.dart';

@immutable
abstract class MusicsEvent {
  const MusicsEvent();
}

class MusicsInit extends MusicsEvent {}

class MusicsSearchInputChanged extends MusicsEvent {
  final String keywords;

  const MusicsSearchInputChanged(this.keywords);
}

class MusicsExecuteSearch extends MusicsEvent {
  final String keywords;

  const MusicsExecuteSearch(this.keywords);
}

class MusicsSelectSong extends MusicsEvent {
  final MusicData music;

  const MusicsSelectSong(this.music);
}
