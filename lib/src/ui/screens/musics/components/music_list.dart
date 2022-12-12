import 'package:fita_music_app/src/states/musics/musics_bloc.dart';
import 'package:flutter/material.dart';

import 'music_item.dart';

/// Creates a list of songs presented in [MusicItem]s.
class MusicList extends StatelessWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MusicsSearchingSelector(
      builder: (searchStatus) {
        // Pre-data handling
        if (searchStatus.isLoading) return const _LoadingIndicator();
        if (searchStatus.isError) {
          return Center(
            key: const Key('search-error-indicator'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'SOMETHING WENT WRONG',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Please check your connection\n'
                  'or try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        return MusicsListSelector(
          builder: (musics) {
            if (musics == null) {
              // Initial View
              return Center(
                child: Icon(
                  Icons.arrow_circle_up,
                  key: const Key('start-indicator'),
                  size: 100,
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(.5),
                ),
              );
            } else if (musics.isEmpty) {
              // Empty View
              return const Center(
                child: Text(
                  'MUSIC NOT FOUND',
                  key: Key('not-found-indicator'),
                ),
              );
            }

            return ListView.builder(
              restorationId: 'MusicList',
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 16,
              ),
              itemCount: musics.length,
              itemBuilder: (BuildContext context, int index) {
                return MusicItem(
                  musicData: musics[index],
                );
              },
            );
          },
        );
      },
    );
  }
}

// COMPONENTS

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        key: Key('data-fetching-indicator'),
      ),
    );
  }
}
