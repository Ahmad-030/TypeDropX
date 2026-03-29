// ═══════════════════════════════════════════════════════════════════════════
//  AUDIO SERVICE  –  singleton background-music controller
//  Persists mute preference with SharedPreferences.
// ═══════════════════════════════════════════════════════════════════════════
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  bool _musicOn = true;
  bool _initialized = false;

  static const _prefKey = 'typedropx_music_on';

  bool get musicOn => _musicOn;

  /// Call once in main() before runApp.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    _musicOn = prefs.getBool(_prefKey) ?? true;

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.45);

    if (_musicOn) await _play();
  }

  Future<void> _play() async {
    await _player.play(AssetSource('music.mp3'));
  }

  Future<void> setMusicOn(bool value) async {
    if (_musicOn == value) return;
    _musicOn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
    if (_musicOn) {
      await _play();
    } else {
      await _player.stop();
    }
  }

  Future<void> toggle() => setMusicOn(!_musicOn);

  Future<void> pause()  => _player.pause();
  Future<void> resume() async { if (_musicOn) await _player.resume(); }

  Future<void> disposePlayer() => _player.dispose();
}