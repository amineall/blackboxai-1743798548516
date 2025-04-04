import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/audio_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Album Art
            Container(
              height: 300,
              width: 300,
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: audioState.currentSong?.imageUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(Icons.music_note, size: 50, color: Colors.white),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(Icons.error, size: 50, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // Song Info
            Text(
              audioState.currentSong?.title ?? 'No song selected',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              audioState.currentSong?.artist ?? 'Unknown artist',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 32),

            // Progress Bar
            StreamBuilder<Duration>(
              stream: ref.read(audioProvider.notifier)._audioService.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = audioState.duration ?? const Duration(minutes: 1);
                
                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble(),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        audioNotifier.seek(Duration(seconds: value.toInt()));
                      },
                      activeColor: Colors.purple.shade800,
                      inactiveColor: Colors.grey.shade800,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          Text(
                            '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  color: audioState.isShuffleOn ? Colors.purple.shade800 : Colors.white,
                  iconSize: 30,
                  onPressed: audioNotifier.toggleShuffle,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 40,
                  onPressed: audioNotifier.skipToPrevious,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      if (audioState.isPlaying) {
                        audioNotifier.pause();
                      } else {
                        audioNotifier.play();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 40,
                  onPressed: audioNotifier.skipToNext,
                ),
                IconButton(
                  icon: const Icon(Icons.repeat),
                  color: audioState.isRepeatOn ? Colors.purple.shade800 : Colors.white,
                  iconSize: 30,
                  onPressed: audioNotifier.toggleRepeat,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Additional buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  iconSize: 30,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  iconSize: 30,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  iconSize: 30,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}