enum LobbyRole { OWNER, PLAYER, KICKED }

LobbyRole lobbyRoleFromString(String value) {
  return LobbyRole.values
      .firstWhere((e) => e.toString().toUpperCase() == value.toUpperCase());
}
