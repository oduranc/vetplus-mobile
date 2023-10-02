import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class ProcedureService {
  static Future<QueryResult> getAllProcedures(String token) async {
    const getAllProceduresQuery = '''
    query {
      getAllProcedure {
        id
        name
        created_at
        updated_at
        status
      }
    }
    ''';

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .query(
          QueryOptions(
            document: gql(getAllProceduresQuery),
          ),
        )
        .timeout(const Duration(seconds: 10));
    return result;
  }
}
