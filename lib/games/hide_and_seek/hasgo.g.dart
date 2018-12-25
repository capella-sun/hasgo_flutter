// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hasgo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HasgoPlayer _$HasgoPlayerFromJson(Map<String, dynamic> json) {
  return HasgoPlayer(
      gameRole: _$enumDecodeNullable(_$HasgoGameRoleEnumMap, json['gameRole']),
      serverPrivilege: _$enumDecodeNullable(
          _$ServerPrivilegeEnumMap, json['serverPrivilege']),
      lobbyRole: _$enumDecodeNullable(_$LobbyRoleEnumMap, json['lobbyRole']))
    ..name = json['name'] as String
    ..uid = json['uid'] as String;
}

Map<String, dynamic> _$HasgoPlayerToJson(HasgoPlayer instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'gameRole': _$HasgoGameRoleEnumMap[instance.gameRole],
      'serverPrivilege': _$ServerPrivilegeEnumMap[instance.serverPrivilege],
      'lobbyRole': _$LobbyRoleEnumMap[instance.lobbyRole]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$HasgoGameRoleEnumMap = <HasgoGameRole, dynamic>{
  HasgoGameRole.HIDER: 'HIDER',
  HasgoGameRole.SEEKER: 'SEEKER'
};

const _$ServerPrivilegeEnumMap = <ServerPrivilege, dynamic>{
  ServerPrivilege.DEFAULT: 'DEFAULT',
  ServerPrivilege.ADMIN: 'ADMIN',
  ServerPrivilege.BANNED: 'BANNED'
};

const _$LobbyRoleEnumMap = <LobbyRole, dynamic>{
  LobbyRole.OWNER: 'OWNER',
  LobbyRole.PLAYER: 'PLAYER',
  LobbyRole.KICKED: 'KICKED'
};

HasgoLobby _$HasgoLobbyFromJson(Map<String, dynamic> json) {
  return HasgoLobby(
      owner: HasgoLobby.ownerFromJson(json['owner'] as Map<String, dynamic>),
      players: HasgoLobby.playersFromJson(
          json['players'] as List<Map<String, dynamic>>),
      lobbyId: json['lobbyId'] as String,
      displayName: json['displayName'] as String)
    ..blackList =
        (json['blackList'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$HasgoLobbyToJson(HasgoLobby instance) =>
    <String, dynamic>{
      'owner': HasgoLobby.ownerToJson(instance.owner),
      'players': HasgoLobby.playersToJson(instance.players),
      'lobbyId': instance.lobbyId,
      'displayName': instance.displayName,
      'blackList': instance.blackList
    };
