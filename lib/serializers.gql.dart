import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' show StandardJsonPlugin;
import 'package:gql_code_builder/src/serializers/operation_serializer.dart'
    show OperationSerializer;
import 'package:gqlflutter/graphql/all_pokemon.data.gql.dart'
    show GAllPokemonData, GAllPokemonData_pokemons;
import 'package:gqlflutter/graphql/all_pokemon.req.gql.dart'
    show GAllPokemonReq;
import 'package:gqlflutter/graphql/all_pokemon.var.gql.dart'
    show GAllPokemonVars;

part 'serializers.gql.g.dart';

final SerializersBuilder _serializersBuilder = _$serializers.toBuilder()
  ..add(OperationSerializer())
  ..addPlugin(StandardJsonPlugin());
@SerializersFor([
  GAllPokemonData,
  GAllPokemonData_pokemons,
  GAllPokemonReq,
  GAllPokemonVars
])
final Serializers serializers = _serializersBuilder.build();
