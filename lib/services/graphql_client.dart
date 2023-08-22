import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

late ValueNotifier<GraphQLClient> globalGraphQLClient;

void initializeGraphQLClient(HttpLink httpLink) {
  final client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );

  globalGraphQLClient = ValueNotifier(client);
}
