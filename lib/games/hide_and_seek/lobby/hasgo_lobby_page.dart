import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasgo_flutter/games/game_modes.dart';
import 'package:hasgo_flutter/lobby/lobby.dart';
// Mock Data Used

class HasgoLobbyPage extends StatefulWidget {
  HasgoLobbyPage(
      {Key key,
      @required this.ownerDisplayName,
      @required this.lobbyDisplayName,
      @required this.gameMode})
      : super(key: key);
  String ownerDisplayName, lobbyDisplayName;
  GameMode gameMode;

  _HasgoLobbyPageState createState() => _HasgoLobbyPageState();
}

class _HasgoLobbyPageState extends State<HasgoLobbyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Lobby _lobby;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getLobbyId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.lobbyDisplayName),
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

  void getLobbyId() async {
    // _lobbyId = '<Default Lobby Name>';
    setState(() {});
  }
}
