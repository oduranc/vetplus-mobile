import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class NotificationService {
  static Future<QueryResult> getAllNotifications(String token) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String getNotificationsQuery = '''
    query {
      getAllNotification {
        id
        id_user
        title
        subtitle
        category
        read
        created_at
        updated_at
        status
        id_entity
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .query(
          QueryOptions(
            document: gql(getNotificationsQuery),
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }

  static Future<QueryResult> handleEmployeeRequest(
      String token, String idEntity, String status) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String handleRequestMutation = '''
    mutation (\$handleEmployeeRequestInput: HandleEmployeeRequestInput!) {
      handleEmployeeRequest(
        handleEmployeeRequestInput: \$handleEmployeeRequestInput
      ) {
        access_token
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(handleRequestMutation),
            variables: {
              "handleEmployeeRequestInput": {
                "id": idEntity,
                "employee_invitation_status": status
              },
            },
          ),
        )
        .timeout(const Duration(seconds: 300));

    print(result);
    return result;
  }

  static Future<QueryResult> registerFmc(String token, String fmc) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String registerFmcMutation = '''
    mutation (\$registerFmcInput: RegisterFmcInput!) {
      registerFMC(registerFmcInput: \$registerFmcInput) {
        result
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(registerFmcMutation),
            variables: {
              "registerFmcInput": {"token_fmc": fmc}
            },
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> markNotificationAsRead(
      String token, String id) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String markNotificationAsReadMutation = '''
    mutation (\$markNotificationAsReadInput: MarkNotificationAsReadInput!) {
      markNotificationAsRead(
        markNotificationAsReadInput: \$markNotificationAsReadInput
      ) {
        result
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(markNotificationAsReadMutation),
            variables: {
              "markNotificationAsReadInput": {"id": id}
            },
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }
}
