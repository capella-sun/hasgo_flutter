import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hasgo_flutter/games/game_modes.dart';
import 'package:hasgo_flutter/lobby/lobby.dart';
import 'package:hasgo_flutter/lobby/lobby_roles.dart';
import 'package:hasgo_flutter/player/player.dart';
import 'package:hasgo_flutter/player/server_privileges.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

part 'hasgo.g.dart';

enum HasgoGameRole { HIDER, SEEKER }

// -------------------------------------
// METHODS
// -------------------------------------

HasgoGameRole hasgoGameRoleFromString(String value) {
  return HasgoGameRole.values
      .firstWhere((e) => e.toString().toUpperCase() == value.toUpperCase());
}

Future updateLobbyBackend(HasgoLobby lobby) async {
  var data = jsonDecode(jsonEncode(lobby.toJson()));

  DocumentReference mLobby = await getLobbyReference(lobby.lobbyId);
  await mLobby.setData(data, merge: true);
}

/// Fetches the first lobby reference for the given lobby ID.
/// Returns `null` if no matching lobbies are found
Future<DocumentReference> getLobbyReference(String lobbyId) async {
  var potentialLobbies = await Firestore.instance
      .collection('lobbies')
      .where('lobbyId', isEqualTo: lobbyId)
      .getDocuments();
  if (potentialLobbies.documents.length == 0) {
    // No Matching lobbies found
    return null; 
  }
  var mLobbySnapshot = potentialLobbies
      .documents[0]; // Select the first lobby that meets our criterion
  return mLobbySnapshot.reference;
}

// -------------------------------------
// Objects
// -------------------------------------

@JsonSerializable()
class HasgoPlayer extends Player {
  // TODO: Need to make deserializers for enums to attach enum prefix
  HasgoGameRole gameRole;
  ServerPrivilege serverPrivilege;
  LobbyRole lobbyRole;

  @JsonKey(ignore: true)
  static final String MANUAL_UID = 'manually-entered';

  HasgoPlayer(
      {this.gameRole,
      this.serverPrivilege = ServerPrivilege.DEFAULT,
      this.lobbyRole = LobbyRole.PLAYER})
      : super();

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
  @JsonKey(toJson: ownerToJson, fromJson: ownerFromJson, nullable: false)
  HasgoPlayer owner;
  @JsonKey(toJson: playersToJson, fromJson: playersFromJson, nullable: false)
  List<HasgoPlayer> players;
  String lobbyId = 'lobby-id';
  String displayName;

  /// This contains a list of blacklisted player uids
  List<String> blackList = [];

  HasgoLobby(
      {@required this.owner,
      @required this.players,
      @required this.lobbyId,
      @required this.displayName});

  factory HasgoLobby.fromJson(Map<String, dynamic> json) {
    json["owner"] = Map<String, dynamic>.from(json["owner"]);

    json["players"] = (json['players'] as List)
        ?.map((e) => e == null ? null : Map<String, dynamic>.from(e))
        ?.toList();

    return _$HasgoLobbyFromJson(json);
  }

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

  static HasgoPlayer ownerFromJson(Map<String, dynamic> json) {
    return HasgoPlayer.fromJson(json);
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

  @override
  GameMode gameMode() {
    return GameMode.HIDE_AND_SEEK;
  }

  static List<HasgoPlayer> playersFromJson(List<Map<String, dynamic>> json) {
    List<HasgoPlayer> players = [];
    for (var player in json) {
      players.add(ownerFromJson(player));
    }
    return players;
  }
}
