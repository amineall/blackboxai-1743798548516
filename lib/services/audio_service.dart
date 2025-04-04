import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/song.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = 0;

  Future<void> init(List<Song> playlist) async {
    _playlist = playlist;
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: playlist.map((song) => AudioSource.uri(Uri.parse(song.audioUrl))).toList(),
      ),
    );
  }

  Future<void> play() => _audioPlayer.play();
  Future<void> pause() => _audioPlayer.pause();
  Future<void> stop() => _audioPlayer.stop();

  Future<void> seek(Duration position) => _audioPlayer.seek(position);
  Future<void> setVolume(double volume) => _audioPlayer.setVolume(volume);

  Future<void> skipToNext() async {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      await _audioPlayer.seekToNext();
    }
  }

  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await _audioPlayer.seekToPrevious();
    }
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;

  void dispose() {
    _audioPlayer.dispose();
  }
}