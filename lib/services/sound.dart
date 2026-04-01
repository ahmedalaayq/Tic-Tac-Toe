import 'package:rxdart/rxdart.dart';
import 'package:tic_tac_toe_game_game/services/spotify_api.dart';
import 'package:tic_tac_toe_game_game/services/stoppable_service.dart';

class SoundService extends StoppableService {
  //To control the music serivces when is minized or closed.
  late BehaviorSubject<bool> _enableSound$;
  BehaviorSubject<bool> get enableSound$ => _enableSound$;

  SoundService() {
    _enableSound$ = BehaviorSubject<bool>.seeded(true);
  }

  @override
  void start() {
    super.start();
    PlayMusic.resume();
    // print('SoundService Started');
  }

  @override
  void stop() {
    super.stop();
    PlayMusic.pause();
    // print('SoundService Stopped');
  }

  void playSpotify() {
    //Connect to Spotify
    PlayMusic().connectToSpotifyRemote();
  }

  void pauseSpotify() {
    //Pause or Play Music based on Enable Switch in Settings
    final bool isSoundEnabled = _enableSound$.value;
    if (!isSoundEnabled) {
      PlayMusic.pause();
    } else {
      PlayMusic.resume();
    }
  }
}
