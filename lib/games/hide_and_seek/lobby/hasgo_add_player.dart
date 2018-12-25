import 'package:flutter/material.dart';
import 'package:hasgo_flutter/games/hide_and_seek/hasgo.dart';
import 'package:hasgo_flutter/util/padding.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddHasgoPlayer extends StatefulWidget {
  AddHasgoPlayer({@required this.lobby});

  /// The lobby to add a player to
  final HasgoLobby lobby;

  _AddHasgoPlayerState createState() => _AddHasgoPlayerState();
}

class _AddHasgoPlayerState extends State<AddHasgoPlayer> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static final _formKey = GlobalKey<FormState>();
  String _name;
  HasgoGameRole _role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Add Player'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            formPad(
                child: TextFormField(
              decoration:
                  InputDecoration(hintText: 'Name', labelText: 'Name *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a _name';
                }
              },
              onSaved: (value) => _name = value,
            )),
            formPad(
                child: DropdownButtonFormField(
              value: _role,
              items: HasgoGameRole.values.map((HasgoGameRole role) {
                String gamerole = role
                    .toString()
                    .split('.')
                    .last; // Get Apple from `Fruit.Apple`
                // final enumGamerole = role.toString();
                return DropdownMenuItem(
                  child: Text(
                    gamerole,
                  ),
                  value: role,
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.toString().isEmpty) {
                  return 'Please select a Game role';
                }
              },
              onChanged: (value) {
                _role = value;
                setState(() {});
              },
              onSaved: (value) => _role = value,
            )),
            RaisedButton(
            child: const Text('Add Player'),
            onPressed: () async => addPlayerAction(context),
          ),
          ],
        ),
      ),
    );
  }

  Future addPlayerAction(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      HasgoPlayer playerToAdd = HasgoPlayer(gameRole: _role).setName(_name).setUid(HasgoPlayer.MANUAL_UID);
      widget.lobby.players.add(playerToAdd);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: SpinKitRotatingCircle(color: Colors.blueGrey,),
        duration: Duration(seconds: 1),
      ));
      await updateLobbyBackend(widget.lobby);
      Navigator.of(context).pop();
    }
  }
}
