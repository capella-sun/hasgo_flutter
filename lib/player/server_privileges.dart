/// The privilege level a user (or a player) has to the backend
enum ServerPrivilege { DEFAULT, ADMIN, BANNED }

ServerPrivilege serverPrivFromString(String value) {
  return ServerPrivilege.values
      .firstWhere((e) => e.toString().toUpperCase() == value.toUpperCase());
}
