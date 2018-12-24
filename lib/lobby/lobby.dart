import 'package:hasgo_flutter/player/player.dart';
import 'package:flutter/material.dart';
import 'package:hasgo_flutter/games/hide_and_seek/lobby/hasgo_lobby_page.dart';
import 'package:hasgo_flutter/util/padding.dart';
import 'package:hasgo_flutter/games/game_modes.dart';

abstract class Lobby {
  List<Player> players;
}

class CreateLobbyPage extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String gameModeString;
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
                  hintText: 'Display Name', labelText: 'Lobby Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name.';
                }
              },
            ),
          ),
          formPad(
            child: DropdownButtonFormField(
              onChanged: (String gameMode) => gameModeString = gameMode,
              items: GameMode.values.map((GameMode mode) {
                String gameMode = getGameModeDisplayName(mode); // Get Apple from `Fruit.Apple`
                return DropdownMenuItem<String>(
                  value: gameModeString,
                  child: Text(gameMode),
                );
              }).toList(),
            )
          ),
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
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text('Creating Lobby'),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HasgoLobbyPage()),
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
