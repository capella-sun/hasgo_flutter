import 'package:hasgo_flutter/player/player.dart';
import 'package:flutter/material.dart';
import 'package:hasgo_flutter/games/hide_and_seek/lobby/hasgo_lobby_page.dart';
import 'package:hasgo_flutter/util/padding.dart';
import 'package:hasgo_flutter/games/game_modes.dart';

abstract class Lobby {
  List<Player> players;
  Player owner;
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
            onPressed: () async => createLobbyPressed(context),
          ),
        ],
      ),
    );
  }

  Future<void> createLobbyPressed(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      
      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: const Text('Creating Lobby'),
      // ));

      print('game mode: $_gameModeString');
      print('lobby: $_lobbyDisplayName');
      print('owner: $_ownerDisplayName');

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HasgoLobbyPage(
                  ownerDisplayName: _ownerDisplayName,
                  lobbyDisplayName: _lobbyDisplayName,
                  gameMode: gameModeFromString(_gameModeString),
                )),
      );
    }
  }
} // CreateLobbyPage

class JoinLobbyPage extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text('Joining Lobby'),
      ));
    }
  }
} // JoinLobbyPage
