import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String title;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.title,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  
  bool _isPlaying = false;
  double _volume = 0.5;
  double _playbackRate = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    // Set up event listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    // Set initial volume
    await _audioPlayer.setVolume(_volume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    await _audioPlayer.play(UrlSource(widget.audioUrl));
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _position = Duration.zero;
    });
  }

  Future<void> _seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

 void _setVolume(double volume) {
    setState(() {
      _volume = volume;
    });
    _audioPlayer.setVolume(volume);
  }

  void _setPlaybackRate(double rate) {
    setState(() {
      _playbackRate = rate;
    });
    _audioPlayer.setPlaybackRate(rate);
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    return '${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player title
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7B68EE),
            ),
          ),
          const SizedBox(height: 16),
          
          // Progress bar
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF7B68EE),
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: const Color(0xFF7B68EE),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration?.inMilliseconds.toDouble() ?? 1000,
                    value: _position?.inMilliseconds.toDouble() ?? 0,
                    onChanged: (value) {
                      _seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Player controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Playback rate button
              PopupMenuButton<double>(
                icon: Icon(
                  Icons.speed,
                  color: Colors.grey[600],
                ),
                onSelected: _setPlaybackRate,
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                  const PopupMenuItem(value: 0.75, child: Text('0.75x')),
                  const PopupMenuItem(value: 1.0, child: Text('1.0x')),
                  const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                  const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                  const PopupMenuItem(value: 2.0, child: Text('2.0x')),
                ],
              ),
              
              // Previous button
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: Colors.grey[600],
                  size: 32,
                ),
                onPressed: () {
                  // TODO: Implement previous track functionality
                },
              ),
              
              // Play/Pause button
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7B68EE),
                ),
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _isPlaying ? _pause : _play,
                ),
              ),
              
              // Next button
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.grey[600],
                  size: 32,
                ),
                onPressed: () {
                  // TODO: Implement next track functionality
                },
              ),
              
              // Volume control
              PopupMenuButton(
                icon: Icon(
                  _volume == 0 
                    ? Icons.volume_off 
                    : _volume < 0.5 
                      ? Icons.volume_down 
                      : Icons.volume_up,
                  color: Colors.grey[600],
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      children: [
                        Text(
                          'Volume',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Slider(
                          min: 0.0,
                          max: 1.0,
                          value: _volume,
                          onChanged: (value) {
                            _setVolume(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}