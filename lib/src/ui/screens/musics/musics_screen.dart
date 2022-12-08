import 'package:fita_music_app/src/data/repositories/musics_repository.dart';
import 'package:fita_music_app/src/states/musics/musics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'components/music_list.dart';
import 'components/music_player.dart';
import 'components/search_bar.dart';

class MusicsScreen extends StatefulWidget {
  static const routeName = '/';

  const MusicsScreen({super.key});

  @override
  State<MusicsScreen> createState() => _MusicsScreenState();
}

class _MusicsScreenState extends State<MusicsScreen> {
  final MusicsRepository _musicsRepository = MusicsRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MusicsBloc>(
      create: (context) => MusicsBloc(
        musicRepository: _musicsRepository,
        audioPlayer: _audioPlayer,
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            SearchBar(),
            Expanded(
              child: MusicList(),
            ),
            MusicPlayer(),
          ],
        ),
      ),
    );
  }
}
