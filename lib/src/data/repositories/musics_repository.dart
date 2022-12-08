import 'package:fita_music_app/src/core/network/base_repository.dart';
import 'package:fita_music_app/src/data/models/music_data.dart';

class MusicsRepository extends BaseRepository {
  MusicsRepository();

  Future<List<MusicData>> searchMusics({
    required String term,
    required String entity,
    required String attribute,
  }) {
    final variables = {
      'term': term,
      'entity': entity,
      'attribute': attribute,
    };
    return clientExecutor(
      execute: () async {
        return get(
          'search',
          query: variables,
        );
      },
      transform: (data) {
        final List<dynamic> results = data['results'];

        return results.map((json) => MusicData.fromMap(json)).toList();
      },
    );
  }
}
