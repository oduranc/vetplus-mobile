import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

late ValueNotifier<GraphQLClient> globalGraphQLClient;

void initializeGraphQLClient(Link link) {
  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );

  globalGraphQLClient = ValueNotifier(client);
}
