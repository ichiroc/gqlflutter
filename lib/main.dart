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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Monsters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Poket Monsters'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void getAllPokemons() async {
    final request = GAllPokemonReq((b) => b..vars.first = 10);
    client.request(request).listen((event) {
      final pokemons = event.data?.pokemons;
      if (pokemons != null) {
        pokemons.forEach((pokemon) {
          print(pokemon.name);
        });
      }
    });
  }

  Client? _client;

  Client get client {
    if (_client == null) {
      final link = HttpLink('https://graphql-pokemon2.vercel.app');
      return _client = Client(link: link);
    } else {
      return _client!; // NOTE: ! 消せないの?
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Operation(
        client: client,
        operationRequest: GAllPokemonReq((b) => b..vars.first = 152),
        builder: (BuildContext context,
            OperationResponse<GAllPokemonData, GAllPokemonVars>? response,
            Object? error) {
          if (response == null || response.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final pokemons = response.data?.pokemons ?? BuiltList();

          return ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];

                return Card(
                  child: Row(children: <Widget>[
                    SizedBox(
                      child: Image.network(
                          pokemon.image ?? 'https://placehold.jp/150x150.png'),
                      width: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${pokemon.name ?? '[unknown]'}'),
                          Text(
                            'MAX HP: ${pokemon.maxHP}',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  ]),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getAllPokemons();
        },
        tooltip: 'Pokemon',
        child: const Text('P'),
      ),
    );
  }
}
