import 'package:get_it/get_it.dart';
import 'package:tic_tac_toe_game_game/services/alert.dart';
import 'package:tic_tac_toe_game_game/services/board.dart';
import 'package:tic_tac_toe_game_game/services/sound.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(BoardService());
  locator.registerSingleton(SoundService());
  locator.registerSingleton(AlertService());
}
