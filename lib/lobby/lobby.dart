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

      var lobby =
          await _createLobby(gameMode, _ownerDisplayName, _lobbyDisplayName);

      _gotoLobby(lobby, gameMode, context);
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
    final deviceId = await DeviceId.getID;

    HasgoPlayer lobbyOwner = HasgoPlayer(
            gameRole: HasgoGameRole.SEEKER,
            serverPrivilege: ServerPrivilege.DEFAULT,
            lobbyRole: LobbyRole.OWNER)
        .setName(ownerDisplayName)
        .setUid(deviceId);

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

  void _gotoLobby(dynamic lobby, GameMode gameMode, BuildContext context) {
    switch (gameMode) {
      case GameMode.HIDE_AND_SEEK:
        _pushContext(
            HasgoLobbyPage(
              lobby: lobby,
            ),
            context);
    }
  }

  void _pushContext(Widget child, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => child),
    );
  }
} // CreateLobbyPage

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
      body: _getForm(),
    );
  }

  Widget _getForm() {
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
            onPressed: joinLobbyPressed,
          ),
        ],
      ),
    );
  }

  Future<void> joinLobbyPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text('Joining Lobby'),
      ));
    }
  }
} // JoinLobbyPage
