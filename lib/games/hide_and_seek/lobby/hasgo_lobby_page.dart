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
import 'hasgo_add_player.dart';
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
        title: Text('Lobby ${widget.lobby.lobbyId.toUpperCase()}'),
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
            child: getPlayers(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: const Text('Add Player'),
                onPressed: () async => await addPlayerAction(context),
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

  Widget getPlayers() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('lobbies')
          .where('lobbyId', isEqualTo: widget.lobby.lobbyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SpinKitChasingDots(
            color: Colors.blueGrey,
          );
        } else {
          // Get first lobby that meets the requirements
          DocumentSnapshot doc = snapshot.data.documents[0];
          return ListView.builder(
            itemCount: doc['players'].length,
            itemBuilder: (context, index) {
              var player = doc['players'][index];
              return ListTile(
                leading: const Icon(Icons.portrait),
                title: Text(player['name']),
                trailing: GestureDetector(
                  onTap: () async {
                    await kickPlayerAction(index, player);
                  },
                  child: const Icon(Icons.cancel),
                ),
              );
            },
          );
        }
      },
    );
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

  HasgoPlayer _getMockPlayer() {
    return HasgoPlayer(
            lobbyRole: LobbyRole.PLAYER,
            serverPrivilege: ServerPrivilege.DEFAULT,
            gameRole: HasgoGameRole.HIDER)
        .setName('newName')
        .setUid('playerUid');
  }

  Future kickPlayerAction(int index, player) async {
    if (player['lobbyRole'] != 'OWNER' &&
        player['lobbyRole'] != LobbyRole.OWNER) {
      if (player['uid'] != HasgoPlayer.MANUAL_UID) {
        widget.lobby.blackList.add(player['uid']);
      }

      widget.lobby.players.removeAt(index);
      await updateLobbyBackend(widget.lobby);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Can\'t kick the lobby owner!'),
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future addPlayerAction(BuildContext context) async {
    /* _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Adding Player...'),
    ));

    widget.lobby.players.add(_getMockPlayer());

    await updateBackend(); */
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddHasgoPlayer(
                lobby: widget.lobby,
              )),
    );
  }

  void initLobby() async {
    // Encoding then decoding because json_annotation decoding decodes as Map<> instead of Map<String, dynamic>.
    // TODO: Make json_annotation decode to Map<String, dynamic> by default
    setState(() {
      _loading = false;
    });
  }
}
