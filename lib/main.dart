import 'package:flutter/material.dart';
import 'lobby/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initFirestore();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }

  void initFirestore() {
    Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  }
}

class HomePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('HaSGO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text('Create'),
              onPressed: () => createLobbyPressed(context),
            ),
            RaisedButton(
              child: const Text('Join'),
              onPressed: () => joinLobbyOnPressed(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void createLobbyPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateLobbyPage()),
    );
  }

  void joinLobbyOnPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinLobbyPage()),
    );
  }
}

class InheritedGameMode extends InheritedWidget {
  InheritedGameMode({Key key, this.child, this.gameMode}) : super(key: key, child: child);

  final Widget child;
  final String gameMode;

  static InheritedGameMode of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedGameMode)as InheritedGameMode);
  }

  @override
  bool updateShouldNotify( InheritedGameMode oldWidget) {
    return false;
  }
}