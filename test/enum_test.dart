import 'package:flutter_test/flutter_test.dart';
import 'package:hasgo_flutter/games/game_modes.dart';
import 'package:hasgo_flutter/player/privileges.dart';

void main() {
  test('Game Modes', () {
    expect(GameMode.HIDE_AND_SEEK, 'hide_and_seek');
  });

  test('Player Privileges', () {
    expect(ServerPrivilege.ADMIN, 'admin');
    expect(ServerPrivilege.BANNED, 'banned');
    expect(ServerPrivilege.DEFAULT, 'default');
  });
}