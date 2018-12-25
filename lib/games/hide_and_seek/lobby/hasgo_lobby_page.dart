import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasgo_flutter/games/game_modes.dart';
import 'package:device_id/device_id.dart';
import 'package:hasgo_flutter/games/hide_and_seek/hasgo.dart';
import 'package:hasgo_flutter/player/server_privileges.dart';
import 'package:hasgo_flutter/lobby/lobby_roles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
// Mock Data Used

class HasgoLobbyPage extends StatefulWidget {
  HasgoLobbyPage({Key key, @required this.lobby}) : super(key: key);

  HasgoLobby lobby;

  _HasgoLobbyPageState createState() => _HasgoLobbyPageState();
}

class _HasgoLobbyPageState extends State<HasgoLobbyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initLobby();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.lobby.displayName),
      ),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    if (_loading) {
      return SpinKitHourGlass(
        color: Colors.cyan,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: getMockPlayers(),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: const Text('Add Player'),
                onPressed: () =>
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Add Player'),
                    )),
              ),
              RaisedButton(
                child: const Text('Start Game'),
                onPressed: () =>
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Start Game'),
                    )),
              ),
              RaisedButton(
                child: const Text('Lobby QR'),
                onPressed: () =>
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Lobby QR'),
                    )),
              ),
            ],
          )
        ],
      );
    }
  }

  List<Widget> getMockPlayers() {
    return const <Widget>[
      ListTile(
        leading: const Icon(Icons.portrait),
        title: const Text('Tyler'),
        trailing: const Icon(Icons.cancel),
      ),
      ListTile(
        leading: const Icon(Icons.portrait),
        title: const Text('Matt'),
        trailing: const Icon(Icons.cancel),
      ),
      ListTile(
        leading: const Icon(Icons.portrait),
        title: const Text('Dominick'),
        trailing: const Icon(Icons.cancel),
      ),
    ];
  }

  void initLobby() async {
    // Encoding then decoding because json_annotation decoding decodes as Map<> instead of Map<String, dynamic>.
    // TODO: Make json_annotation decode to Map<String, dynamic> by default
    setState(() {
      _loading = false;
    });
  }
}
