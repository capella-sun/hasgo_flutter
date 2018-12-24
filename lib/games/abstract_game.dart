import 'package:hasgo_flutter/lobby/lobby.dart';
import 'game_modes.dart';

abstract class AbstractGame {
  /// Indicates the `GameMode` of this Game
  GameMode gameMode;

  /// Contains the players
  Lobby lobby;

  dynamic end();
  dynamic start();
}
