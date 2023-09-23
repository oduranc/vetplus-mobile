import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class ClinicService {
  static Future<QueryResult> getAllClinic(String token) async {
    const getAllClinicQuery = '''
    query {
      getAllClinic {
        id
        id_owner
        name
        telephone_number
        google_maps_url
        email
        image
        address
        created_at
        updated_at
        status
        clinicSummaryScore {
          total_points
          total_users
        }
      }
    }
    ''';

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link = authLink.concat(HttpLink(dotenv.env['API_LINK']!));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .query(
          QueryOptions(
            document: gql(getAllClinicQuery),
          ),
        )
        .timeout(const Duration(seconds: 10));
    return result;
  }
}
