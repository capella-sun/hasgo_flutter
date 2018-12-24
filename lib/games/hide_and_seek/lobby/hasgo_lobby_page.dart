import 'package:flutter/material.dart';

class CreateHasgoLobbyPage extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
          _pad(
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

class JoinHasgoLobbyPage extends StatelessWidget {
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
          _pad(
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
          _pad(
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

// Mock Data Used

class HasgoLobbyPage extends StatefulWidget {
  _HasgoLobbyPageState createState() => _HasgoLobbyPageState();
}

class _HasgoLobbyPageState extends State<HasgoLobbyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _lobbyId;

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
        title: Text(_lobbyId ?? 'Lobby'),
      ),
      body: Column(
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
      ),
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

  void getLobbyId() async {
    _lobbyId = '<Default Lobby Name>';
    setState(() {});
  }
}

Widget _pad({@required Widget child}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: child,
  );
}
