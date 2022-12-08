import 'dart:convert';

class MusicData {
  final int? trackId;
  final String trackName;
  final String artworkUrl;
  final String artistName;
  final String collectionName;
  final String previewUrl;

  MusicData({
    this.trackId,
    this.artworkUrl = '',
    this.trackName = '',
    this.artistName = '',
    this.collectionName = '',
    this.previewUrl = '',
  });

  @override
  String toString() {
    return 'MusicData(trackId: $trackId, trackName: $trackName, artworkUrl: $artworkUrl, artistName: $artistName, collectionName: $collectionName, previewUrl: $previewUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'trackName': trackName,
      'artworkUrl': artworkUrl,
      'artistName': artistName,
      'collectionName': collectionName,
      'previewUrl': previewUrl,
    };
  }

  factory MusicData.fromMap(Map<String, dynamic> map) {
    return MusicData(
      trackId: map['trackId'] ?? '',
      trackName: map['trackName'] ?? '',
      artworkUrl: map['artworkUrl100'] ?? '',
      artistName: map['artistName'] ?? '',
      collectionName: map['collectionName'] ?? '',
      previewUrl: map['previewUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicData.fromJson(dynamic source) =>
      MusicData.fromMap(json.decode(source));
}
