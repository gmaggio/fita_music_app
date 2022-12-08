import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'package:fita_music_app/src/data/models/music_data.dart';
import 'package:fita_music_app/src/states/musics/musics_bloc.dart';

/// Creates a music player that consists of the music's details and the music
/// controller.
class MusicPlayer extends StatelessWidget {
  const MusicPlayer({
    Key? key,
  }) : super(key: key);

  static const double defaultIconSize = 50;

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = context.read<MusicsBloc>().audioPlayer;
    final double screenBottomPadding = MediaQuery.of(context).padding.bottom;
    final ThemeData theme = Theme.of(context);
    final Color defaultContentColor = theme.colorScheme.onSecondary;

    return DefaultTextStyle.merge(
      style: TextStyle(
        color: defaultContentColor,
      ),
      child: MusicsSelectedSelector(
        builder: (musicSelected) {
          if (musicSelected == null) return Container();

          return Container(
            key: const Key('music-player'),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
            ).copyWith(
              top: 16,
              bottom: 16 + screenBottomPadding,
            ),
            child: Row(
              children: [
                ..._musicDetails(
                  theme: theme,
                  musicSelected: musicSelected,
                ),
                const SizedBox(width: 16),

                // Controls
                StreamBuilder<PlayerState>(
                  stream: audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final PlayerState? playerState = snapshot.data;

                    return _musicController(
                      context,
                      playerState: playerState,
                      audioPlayer: audioPlayer,
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // COMPONENTS

  List<Widget> _musicDetails({
    required ThemeData theme,
    required MusicData musicSelected,
  }) {
    const double coverBorderWidth = 3;
    const double coverSize = 50;

    return [
      // The Album Cover
      Container(
        width: coverSize + coverBorderWidth,
        height: coverSize + coverBorderWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.onPrimary,
            width: coverBorderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(coverSize),
          child: Image.network(
            musicSelected.artworkUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) {
              return Container(
                width: defaultIconSize,
                height: defaultIconSize,
                color: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.album,
                  size: defaultIconSize * .75,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            },
          ),
        ),
      ),
      const SizedBox(width: 16),

      // The Music Info
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The Song Title
            Text(
              musicSelected.trackName,
              key: const Key('music-detail-title'),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // The artist
            Text(
              musicSelected.artistName,
              style: theme.textTheme.subtitle2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // The Album Title
            Text(
              musicSelected.collectionName,
              style: theme.textTheme.caption?.copyWith(
                color: theme.textTheme.subtitle2?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      )
    ];
  }

  Widget _musicController(
    BuildContext context, {
    required PlayerState? playerState,
    required AudioPlayer audioPlayer,
  }) {
    final ProcessingState? processingState = playerState?.processingState;

    return BlocConsumer<MusicsBloc, MusicsState>(
      listenWhen: (previous, current) {
        return previous.isAudioError != current.isAudioError;
      },
      listener: (context, state) {
        if (state.isAudioError) {
          _showErrorSnackBar(context);
        }
      },
      builder: (context, state) {
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return SizedBox(
            key: const Key('music-fetching-indicator'),
            width: defaultIconSize,
            height: defaultIconSize,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else if (audioPlayer.playing != true) {
          return MusicControllerButton(
            keySuffix: 'play',
            icon: Icons.play_arrow,
            onPressed: audioPlayer.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return MusicControllerButton(
            keySuffix: 'pause',
            icon: Icons.pause,
            onPressed: audioPlayer.pause,
          );
        } else {
          return MusicControllerButton(
            keySuffix: 'replay',
            icon: Icons.replay,
            onPressed: () => audioPlayer.seek(
              Duration.zero,
              index: audioPlayer.effectiveIndices?.first,
            ),
          );
        }
      },
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        final SnackBar snackBar = SnackBar(
          content: Text(
            'Please check your connection or try again later.',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: theme.colorScheme.primary,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}

class MusicControllerButton extends StatelessWidget {
  final String keySuffix;
  final IconData icon;
  final VoidCallback onPressed;

  const MusicControllerButton({
    Key? key,
    required this.keySuffix,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key('music-control-$keySuffix'),
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(icon),
      padding: EdgeInsets.zero,
      iconSize: MusicPlayer.defaultIconSize,
      onPressed: onPressed,
    );
  }
}
