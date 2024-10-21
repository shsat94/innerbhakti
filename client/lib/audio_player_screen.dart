import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<String> trackUrls;
  final int initialIndex;

  AudioPlayerScreen({required this.trackUrls, this.initialIndex = 0});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  int currentTrackIndex = 0;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentTrackIndex = widget.initialIndex;

    // Listen for changes in player state
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing; // Use lowercase 'playing'
      });
    });

    // Listen for changes in duration and position
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });

    _playTrack(widget.trackUrls[currentTrackIndex]);
  }

  void _playTrack(String url) async {
    await _audioPlayer.play(UrlSource(url)); // Play the track
  }

  void _pauseTrack() async {
    await _audioPlayer.pause(); // Pause the track
  }

  void _playNextTrack() {
    if (currentTrackIndex < widget.trackUrls.length - 1) {
      setState(() {
        currentTrackIndex++;
        position = Duration.zero; // Reset position for the next track
      });
      _playTrack(widget.trackUrls[currentTrackIndex]);
    }
  }

  void _playPreviousTrack() {
    if (currentTrackIndex > 0) {
      setState(() {
        currentTrackIndex--;
        position = Duration.zero; // Reset position for the previous track
      });
      _playTrack(widget.trackUrls[currentTrackIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Playing track ${currentTrackIndex + 1}'),
            Slider(
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  position = Duration(seconds: newValue.toInt());
                });
                _audioPlayer.seek(position); // Seek to the new position
              },
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 64,
              onPressed: () {
                if (isPlaying) {
                  _pauseTrack();
                } else {
                  _playTrack(widget.trackUrls[currentTrackIndex]);
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  iconSize: 48,
                  onPressed: _playPreviousTrack,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  iconSize: 48,
                  onPressed: _playNextTrack,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player when done
    super.dispose();
  }
}
