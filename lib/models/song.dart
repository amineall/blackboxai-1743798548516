class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String audioUrl;
  final String imageUrl;
  final Duration duration;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.audioUrl,
    required this.imageUrl,
    required this.duration,
  });

  // Helper method to create a sample playlist
  static List<Song> sampleSongs() {
    return [
      Song(
        id: '1',
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        album: 'After Hours',
        audioUrl: 'https://example.com/songs/1.mp3',
        imageUrl: 'https://example.com/images/1.jpg',
        duration: const Duration(minutes: 3, seconds: 20),
      ),
      Song(
        id: '2',
        title: 'Save Your Tears',
        artist: 'The Weeknd',
        album: 'After Hours',
        audioUrl: 'https://example.com/songs/2.mp3',
        imageUrl: 'https://example.com/images/2.jpg',
        duration: const Duration(minutes: 3, seconds: 35),
      ),
      Song(
        id: '3',
        title: 'Starboy',
        artist: 'The Weeknd ft. Daft Punk',
        album: 'Starboy',
        audioUrl: 'https://example.com/songs/3.mp3',
        imageUrl: 'https://example.com/images/3.jpg',
        duration: const Duration(minutes: 3, seconds: 50),
      ),
    ];
  }
}