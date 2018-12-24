import 'package:flutter_test/flutter_test.dart';
import 'package:hasgo_flutter/games/hide_and_seek/hasgo.dart';
import 'package:hasgo_flutter/player/server_privileges.dart';
import 'package:hasgo_flutter/lobby/lobby_roles.dart';

void main() {
  test('Json Test', () {
    HasgoPlayer player = HasgoPlayer(
            gameRole: HasgoGameRole.HIDER,
            serverPrivilege: ServerPrivilege.DEFAULT,
            lobbyRole: LobbyRole.OWNER)
        .setName('Todd')
        .setUid('newUid');

    HasgoLobby lobby = HasgoLobby(owner: player, players: [player]);
    // print(player.toJson());

    Map playerJson = player.toJson();
    expect(playerJson['name'], 'Todd');
    expect(playerJson['gameRole'], 'HIDER');

    Map lobbyJson = lobby.toJson();
    expect(lobbyJson['owner'], playerJson);
    expect(lobbyJson['players'][0], playerJson);

    // print(lobby.toJson());
  });
}