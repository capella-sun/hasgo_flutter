import 'package:hasgo_flutter/player/player.dart';
import 'package:hasgo_flutter/player/server_privileges.dart';
import 'package:hasgo_flutter/lobby/lobby_roles.dart';

enum HasgoGameRole { HIDER, SEEKER }

class HasgoPlayer extends Player {
  HasgoGameRole gameRole;
  ServerPrivilege serverPrivilege;
  LobbyRole lobbyRole;
}