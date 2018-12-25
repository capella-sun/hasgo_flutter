import 'package:hasgo_flutter/player/player.dart';
import 'package:hasgo_flutter/player/server_privileges.dart';
import 'package:hasgo_flutter/lobby/lobby_roles.dart';
import 'package:hasgo_flutter/lobby/lobby.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

part 'hasgo.g.dart';

enum HasgoGameRole { HIDER, SEEKER }

HasgoGameRole hasgoGameRoleFromString(String value) {
  return HasgoGameRole.values
      .firstWhere((e) => e.toString().toUpperCase() == value.toUpperCase());
}

@JsonSerializable()
class HasgoPlayer extends Player {
  // TODO: Need to make deserializers for enums to attach enum prefix
  HasgoGameRole gameRole;
  ServerPrivilege serverPrivilege;
  LobbyRole lobbyRole;

  HasgoPlayer({this.gameRole, this.serverPrivilege, this.lobbyRole}) : super();

  bool validate() {
    return (gameRole != null &&
        serverPrivilege != null &&
        lobbyRole != null &&
        name != null &&
        uid != null &&
        name.isNotEmpty &&
        uid.isNotEmpty);
  }

  HasgoPlayer setName(String newName) {
    name = newName;
    return this;
  }

  HasgoPlayer setUid(String newUid) {
    uid = newUid;
    return this;
  }

  factory HasgoPlayer.fromJson(Map<String, dynamic> json) =>
      _$HasgoPlayerFromJson(json);

  Map<String, dynamic> toJson() => _$HasgoPlayerToJson(this);
}

/// If owner is a player, Owner should be included in the `players` part of the constructor.
/// The owner is NOT added to the list of players internally
@JsonSerializable()
class HasgoLobby extends Lobby {
  @JsonKey(toJson: ownerToJson)
  HasgoPlayer owner;
  @JsonKey(toJson: playersToJson)
  List<HasgoPlayer> players;
  String lobbyId = 'lobby-id';
  String displayName;

  HasgoLobby(
      {@required this.owner, @required this.players, @required this.lobbyId, @required this.displayName});

  factory HasgoLobby.fromJson(Map<String, dynamic> json) =>
      _$HasgoLobbyFromJson(json);

  Map<String, dynamic> toJson() => _$HasgoLobbyToJson(this);

  @override

  /// Returns the owner of the lobby
  getOwner() {
    return owner;
  }

  @override

  /// Returns a list of players in the lobby
  List getPlayers() {
    return players;
  }

  @override
  getLobbyId() {
    return lobbyId;
  }

  static Map<String, dynamic> ownerToJson(HasgoPlayer owner) {
    // TODO: Implement
    return owner.toJson();
  }

  static List<Map<String, dynamic>> playersToJson(List<HasgoPlayer> players) {
    // TODO: Implement
    List<Map<String, dynamic>> ret = [];
    for (var player in players) {
      ret.add(player.toJson());
    }
    return ret;
  }

  /// Returns a 4-digit id from a v4 Uuid
  static String getIdFromUuid(String uuid) {
    return uuid.substring(9, 13);
  }

  static String makeNewId() {
    final uuid = Uuid().v4(options: {'rng': UuidUtil.cryptoRNG});
    return getIdFromUuid(uuid);
  }
}
