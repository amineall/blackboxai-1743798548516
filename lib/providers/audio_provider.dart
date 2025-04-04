import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/models/song.dart';

class AudioState {
  final List<Song> playlist;
  final Song? currentSong;
  final bool isPlaying;
  final Duration position;
  final Duration? duration;
  final double volume;
  final bool isShuffleOn;
  final bool isRepeatOn;

  const AudioState({
    required this.playlist,
    this.currentSong,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration,
    this.volume = 1.0,
    this.isShuffleOn = false,
    this.isRepeatOn = false,
  });

  factory AudioState.initial() => AudioState(playlist: []);

  AudioState copyWith({
    List<Song>? playlist,
    Song? currentSong,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? volume,
    bool? isShuffleOn,
    bool? isRepeatOn,
  }) {
    return AudioState(
      playlist: playlist ?? this.playlist,
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      isShuffleOn: isShuffleOn ?? this.isShuffleOn,
      isRepeatOn: isRepeatOn ?? this.isRepeatOn,
    );
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier();
});

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _audioService = AudioPlayerService();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioNotifier() : super(AudioState.initial()) {
    _init();
  }

  Future<void> _init() async {
    await _audioService.init(Song.sampleSongs());
    _positionSubscription = _audioService.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });
    _durationSubscription = _audioService.durationStream.listen((duration) {
      state = state.copyWith(duration: duration);
    });
    _playerStateSubscription = _audioService.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState.playing,
        currentSong: state.playlist.isNotEmpty ? state.playlist[0] : null,
      );
    });
    state = state.copyWith(
      playlist: Song.sampleSongs(),
      currentSong: Song.sampleSongs().first,
    );
  }

  Future<void> play() async {
    await _audioService.play();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> pause() async {
    await _audioService.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
    state = state.copyWith(position: position);
  }

  Future<void> skipToNext() async {
    await _audioService.skipToNext();
  }

  Future<void> skipToPrevious() async {
    await _audioService.skipToPrevious();
  }

  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  void toggleShuffle() {
    state = state.copyWith(isShuffleOn: !state.isShuffleOn);
  }

  void toggleRepeat() {
    state = state.copyWith(isRepeatOn: !state.isRepeatOn);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}