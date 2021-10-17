import 'package:built_collection/built_collection.dart';
import 'package:ferry/ferry.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';

import 'package:gql_http_link/gql_http_link.dart';
import 'package:gqlflutter/graphql/all_pokemon.data.gql.dart';
import 'package:gqlflutter/graphql/all_pokemon.req.gql.dart';
import 'package:gqlflutter/graphql/all_pokemon.var.gql.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: const MyHomePage(title: 'Poket monsters'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    getAllPokemons();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void getAllPokemons() async {
    final request = GAllPokemonReq(
      (b) =>
      b..vars.first = 10
    );
    client.request(request).listen((event) {
        final pokemons = event.data?.pokemons;
        if(pokemons != null) {
          pokemons.forEach((pokemon) {
              print(pokemon.name);
          });
        }
    });
  }

  Client? _client;

  Client get client {
    if(_client == null) {
      final link = HttpLink('https://graphql-pokemon2.vercel.app');
      return _client = Client(link: link);
    } else {
      return _client!;          // NOTE: ! 消せないの?
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Operation(
        client: client,
        operationRequest: GAllPokemonReq((b) => b..vars.first = 50),
        builder: (BuildContext context, OperationResponse<GAllPokemonData, GAllPokemonVars>? response, Object? error) {
          if(response == null || response.loading) return const Center(child: CircularProgressIndicator());

          final pokemons = response.data?.pokemons ?? BuiltList();

          return ListView.builder(
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              final pokemonName = pokemon.name ?? 'none';

              return Card(
                child: Column(
                  children: <Widget> [
                    Text(pokemonName)
                  ]
                ),
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
