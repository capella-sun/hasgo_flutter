import 'package:flutter/material.dart';
import 'package:hasgo_flutter/games/game_modes.dart';
// Hasgo imports
import 'package:hasgo_flutter/games/hide_and_seek/hasgo.dart';
import 'package:hasgo_flutter/games/hide_and_seek/lobby/hasgo_lobby_page.dart';

import 'package:hasgo_flutter/player/server_privileges.dart';
import 'package:hasgo_flutter/util/padding.dart';
import 'package:hasgo_flutter/lobby/lobby_roles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:device_id/device_id.dart';

abstract class Lobby {
  List getPlayers();
  dynamic getOwner();
  dynamic getLobbyId();

  /// Should return the game mode of the lobby
  GameMode gameMode();
}

class CreateLobbyPage extends StatefulWidget {
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobbyPage> {
  static final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _gameModeString;
  String _lobbyDisplayName, _ownerDisplayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Create Lobby'),
      ),
      body: _getForm(context),
    );
  }

  Widget _getForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          formPad(
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter Lobby Name', labelText: 'Lobby Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name.';
                }
              },
              onSaved: (value) => _lobbyDisplayName = value,
            ),
          ),
          formPad(
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Display Name', labelText: 'Your Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name.';
                }
              },
              onSaved: (value) => _ownerDisplayName = value,
            ),
          ),
          formPad(
              child: DropdownButtonFormField(
            value: _gameModeString,
            onChanged: (String gameMode) {
              _gameModeString = gameMode;
              setState(
                  () {}); // Without this, the dropdown will not update immediately.
            },
            items: GameMode.values.map((GameMode mode) {
              String gameMode =
                  getGameModeDisplayName(mode); // Get Apple from `Fruit.Apple`
              final enumGameMode = mode.toString();
              return DropdownMenuItem(
                child: Text(
                  gameMode,
                  style: TextStyle(color: Colors.white),
                ),
                value: enumGameMode,
              );
            }).toList(),
            onSaved: (String value) {
              _gameModeString = value;
            },
            validator: (value) {
              if (value == null || value.toString().isEmpty) {
                return 'Please select a Game Mode';
              }
            },
          )),
          RaisedButton(
            child: const Text('Create'),
            onPressed: () async => createLobbyAction(context),
          ),
        ],
      ),
    );
  }

  Future<void> createLobbyAction(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text('Creating Lobby'),
      ));

      print('game mode: $_gameModeString');
      print('lobby: $_lobbyDisplayName');
      print('owner: $_ownerDisplayName');

      GameMode gameMode = gameModeFromString(_gameModeString);

      Lobby lobby =
          await _createLobby(gameMode, _ownerDisplayName, _lobbyDisplayName);

      _gotoLobby(lobby, lobby.getOwner(), gameMode, context);
    }
  }

  /// Will crash the app if gameMode is null!
  Future _createLobby(GameMode gameMode, String ownerDisplayName,
      String lobbyDisplayName) async {
    switch (gameMode) {
      case GameMode.HIDE_AND_SEEK:
        return _createHasgoLobby(gameMode, ownerDisplayName, lobbyDisplayName);
    }
  }

  Future<HasgoLobby> _createHasgoLobby(GameMode gameMode,
      String ownerDisplayName, String lobbyDisplayName) async {
    HasgoPlayer lobbyOwner =
        await _getThisPlayer(ownerDisplayName, owner: true);

    final lobby = HasgoLobby(
        owner: lobbyOwner,
        players: [lobbyOwner],
        lobbyId: HasgoLobby.makeNewId(),
        displayName: lobbyDisplayName);

    await Firestore.instance
        .collection('lobbies')
        .document()
        .setData(jsonDecode(jsonEncode(lobby.toJson())));
    return lobby;
  }
} // CreateLobbyPage

// -----------------------------------------------------
// Methods
// -----------------------------------------------------

void _gotoLobby(
    dynamic lobby, dynamic player, GameMode gameMode, BuildContext context) {
  switch (gameMode) {
    case GameMode.HIDE_AND_SEEK:
      _pushContext(

          InheritedUser(

            child: HasgoLobbyPage(
              lobby: lobby,
            ),
            
            player: player as HasgoPlayer),

          context
      );
  }
}

Future<HasgoPlayer> _getThisPlayer(String displayName,
    {bool owner = false}) async {
  final uid = await DeviceId.getID;
  if (owner) {
    return HasgoPlayer(
            gameRole: HasgoGameRole.SEEKER,
            serverPrivilege: ServerPrivilege.DEFAULT,
            lobbyRole: LobbyRole.OWNER)
        .setName(displayName)
        .setUid(uid);
  } else {
    return HasgoPlayer(gameRole: HasgoGameRole.HIDER)
        .setUid(uid)
        .setName(displayName);
  }
}

void _pushContext(Widget child, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => child),
  );
}

// -----------------------------------------------------
// END
// -----------------------------------------------------

class JoinLobbyPage extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String displayName, lobbyId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Join Lobby'),
      ),
      body: _getForm(context),
    );
  }

  Widget _getForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          formPad(
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Lobby ID', labelText: 'Lobby Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a Lobby ID.';
                }
              },
              onSaved: (value) => lobbyId = value,
            ),
          ),
          formPad(
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Display Name', labelText: 'Your Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name.';
                }
              },
              onSaved: (value) => displayName = value,
            ),
          ),
          RaisedButton(
            child: const Text('Join'),
            onPressed: () async => joinLobbyPressed(context),
          ),
        ],
      ),
    );
  }

  Future<void> joinLobbyPressed(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text('Joining Lobby'),
        duration: const Duration(seconds: 1),
      ));

      final lobbyRef = await getLobbyReference(lobbyId);

      if (lobbyRef == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: const Text('Hmm. We can\'t find that lobby!'),
          duration: const Duration(seconds: 1),
        ));
        return;
      }

      final lobbySnapShot = await lobbyRef.get();
      if (lobbySnapShot != null && lobbySnapShot.exists) {
        final player = await _getThisPlayer(displayName);
        var data = lobbySnapShot.data;

        final lobby = HasgoLobby.fromJson(data);
        if (lobby.blackList.contains(player.uid)) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: const Text('You\'ve been kicked from this lobby!'),
            duration: const Duration(seconds: 1),
          ));
          return;
        } else {
          lobby.players.add(player);
          await updateLobbyBackend(lobby);
          _gotoLobby(lobby, player, lobby.gameMode(), context);
        }
      } else {
        // TODO: Implement
      }
    }
  }
} // JoinLobbyPage

class InheritedUser extends InheritedWidget {
  InheritedUser({Key key, this.child, this.player})
      : super(key: key, child: child);

  final Widget child;
  final HasgoPlayer player;

  static InheritedUser of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedUser)
        as InheritedUser);
  }

  @override
  bool updateShouldNotify(InheritedUser oldWidget) {
    return oldWidget.player.uid != player.uid;
  }
}
