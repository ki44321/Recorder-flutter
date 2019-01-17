import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart' show VoidCallback;
import 'package:recorder/audio/base_audio.dart';

class Player extends BaseAudio {
  final _audioCache = AudioCache();
  AudioPlayer _player;
  VoidCallback onPlayFromLocalComplete;
  bool _isPlayingLocal = false;

  Player(VoidCallback onPlayFromLocalComplete) {
    this.onPlayFromLocalComplete = onPlayFromLocalComplete;
  }

  Future<bool> get hasPlayingResult async => await fileManager.existFinalFile;

  playFromAssets(String path) async {
    stop();
    _player = await _audioCache.loop(path);
  }

  playFromLocal() async {
    await stop();
    _player = AudioPlayer();
    await _player.play(fileManager.finalFilePath, isLocal: true);

    _isPlayingLocal = true;

    _player.completionHandler = () {
      _isPlayingLocal = false;
      onPlayFromLocalComplete();
    };
  }

  Future<void> stop() async {
    if (_player?.state == AudioPlayerState.PLAYING) {
      await _player?.stop();
    }

    _isPlayingLocal = false;
  }

  stopLocal() async {
    if (_isPlayingLocal) {
      await stop();
    }
  }

  release() async {
    await _player?.release();
  }
}
