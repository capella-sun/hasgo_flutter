import 'package:flutter_test/flutter_test.dart';
import 'package:hasgo_flutter/games/game_modes.dart';
import 'package:hasgo_flutter/player/server_privileges.dart';
import 'package:hasgo_flutter/games/hide_and_seek/hasgo.dart';

void main() {

  // These tests prevent silent breakage from potential future Dart updates
  test('Player Privileges', () {
    expect(ServerPrivilege.ADMIN.toString(), "ServerPrivilege.ADMIN");
    expect(ServerPrivilege.BANNED.toString(), "ServerPrivilege.BANNED");
    expect(ServerPrivilege.DEFAULT.toString(), "ServerPrivilege.DEFAULT");
  });

  test('Game Modes', () {
    expect(GameMode.HIDE_AND_SEEK.toString(), "GameMode.HIDE_AND_SEEK");
  });

  test('Hasgo Enums', () {
    expect(HasgoGameRole.HIDER.toString(), "HasgoGameRole.HIDER");
    expect(HasgoGameRole.SEEKER.toString(), "HasgoGameRole.SEEKER");
  });
}