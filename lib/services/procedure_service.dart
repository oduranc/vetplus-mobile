import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class ProcedureService {
  static Future<QueryResult> getAllProcedures() async {
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

    final QueryResult result = await globalGraphQLClient.value
        .query(
          QueryOptions(
            document: gql(getAllProceduresQuery),
          ),
        )
        .timeout(const Duration(seconds: 10));
    return result;
  }
}
