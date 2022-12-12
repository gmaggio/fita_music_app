import 'package:fita_music_app/src/data/models/music_data.dart';
import 'package:fita_music_app/src/states/musics/musics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Creates the container for the music items which consists of the song title,
/// the artist, the album, and the album's artwork.
class MusicItem extends StatelessWidget {
  /// The necessary data for the music.
  final MusicData musicData;

  const MusicItem({
    Key? key,
    required this.musicData,
  }) : super(key: key);

  static const double defaultIconSize = 50;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<MusicsBloc, MusicsState>(
      buildWhen: (previous, current) {
        // Makes sure items only rebuild if there's changes.
        if (previous.musicSelected?.trackId != current.musicSelected?.trackId) {
          return [
            previous.musicSelected?.trackId,
            current.musicSelected?.trackId,
          ].contains(musicData.trackId);
        }
        return false;
      },
      builder: (context, state) {
        final bool isSelected = state.musicSelected != null &&
            state.musicSelected!.trackId == musicData.trackId;

        return ListTile(
          key: Key('music-${musicData.trackId}'),
          contentPadding: EdgeInsets.zero,

          // The Album Cover
          leading: Container(
            width: defaultIconSize,
            height: defaultIconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(
                      color: theme.colorScheme.primary,
                      width: 3,
                    )
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                musicData.artworkUrl,
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

          minVerticalPadding: 16,
          horizontalTitleGap: 16,

          // The Song Title
          title: Text(
            musicData.trackName,
            key: const Key('music-title'),
            style: theme.textTheme.bodyText2?.copyWith(
              color: isSelected ? theme.colorScheme.primaryContainer : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // The Artist
              Text(
                musicData.artistName,
                style: theme.textTheme.subtitle1?.copyWith(
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // The Album Title
              Text(
                musicData.collectionName,
                style: theme.textTheme.caption?.copyWith(
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // The Music's Active Indicator
          trailing: isSelected
              ? SizedBox(
                  key: const Key('music-active-indicator'),
                  width: defaultIconSize,
                  height: defaultIconSize,
                  child: Icon(
                    Icons.music_note,
                    size: defaultIconSize,
                    color: theme.colorScheme.primary,
                  ),
                )
              : null,
          onTap: !isSelected
              ? () => _onTapItem(
                    context,
                    musicSelected: musicData,
                  )
              : null,
        );
      },
    );
  }

  // ACTIONS

  void _onTapItem(
    BuildContext context, {
    required MusicData musicSelected,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<MusicsBloc>().add(MusicsSelectSong(musicSelected));
  }
}
