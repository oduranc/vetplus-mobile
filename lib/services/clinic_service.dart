import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class ClinicService {
  static Future<QueryResult> getAllClinic() async {
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
        services
        ClinicSummaryScore {
          total_points
          total_users
        }
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .query(
          QueryOptions(
            document: gql(getAllClinicQuery),
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }

  static Future<QueryResult> getClinicById(String id) async {
    const getClinicQuery = '''
    query (\$getClinicByIdInput: GenericByIdInput!) {
      getClinicById(getClinicByIdInput: \$getClinicByIdInput) {
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
        services
        ClinicSummaryScore {
          total_points
          total_users
        }
        schedule {
          workingDays {
            day
            startTime
            endTime
          }
          nonWorkingDays
        }
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .query(
          QueryOptions(
            document: gql(getClinicQuery),
            variables: {
              'getClinicByIdInput': {
                'id': id,
              }
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

    print(result);
    return result;
  }

  static Future<QueryResult> getClinicEmployees(String id) async {
    const getAllEmployeeQuery = '''
    query (\$getAllEmployeeByClinicIdInput: GetAllEmployeeByClinicIdInput!) {
      getAllEmployee(
        getAllEmployeeByClinicIdInput: \$getAllEmployeeByClinicIdInput
      ) {
        id_clinic
        id_employee
        employee_invitation_status
        created_at
        updated_at
        status
        Employee {
          names
          surnames
          image
          email
          status
        }
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .query(
          QueryOptions(
            document: gql(getAllEmployeeQuery),
            variables: {
              'getAllEmployeeByClinicIdInput': {
                'id': id,
              }
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }

  static Future<QueryResult> getClinicComments(String id) async {
    const getAllCommentsQuery = '''
    query (\$genericByIdInput: GenericByIdInput!) {
      getAllCommentByIdClinic(genericByIdInput: \$genericByIdInput) {
        id
        id_clinic
        id_owner
        comment
        created_at
        updated_at
        status
        Owner {
          names
          surnames
          image
          ClinicUsers {
            points
          }
        }
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .query(
          QueryOptions(
            document: gql(getAllCommentsQuery),
            variables: {
              'genericByIdInput': {
                'id': id,
              }
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> getFavoriteClinics(String token) async {
    const getFavoriteClinicsQuery = '''
    query {
      getAllFavoriteClinic {
        Clinic {
          name
          address
          image
        }
        id_user
        id_clinic
        favorite
        points
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
            document: gql(getFavoriteClinicsQuery),
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }

  static Future<QueryResult> markClinicAsFavorite(
      String token, String id, bool favorite) async {
    const markAsFavoriteMutation = '''
    mutation (\$markAsFavoriteClinicInput: MarkAsFavoriteClinicInput!) {
      markAsFavoriteClinic(markAsFavoriteClinicInput: \$markAsFavoriteClinicInput) {
        result
      }
    }
    ''';

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(document: gql(markAsFavoriteMutation), variables: {
            'markAsFavoriteClinicInput': {
              'id': id,
              'favorite': favorite,
            },
          }),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }

  static Future<QueryResult> scoreClinic(
      String token, String id, int score) async {
    const scoreClinicMutation = '''
    mutation (\$scoreClinicInput: ScoreClinicInput!) {
      scoreClinic(scoreClinicInput: \$scoreClinicInput) {
        result
      }
    }
    ''';

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(document: gql(scoreClinicMutation), variables: {
            'scoreClinicInput': {
              'id_clinic': id,
              'score': score,
            },
          }),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }

  static Future<QueryResult> registerComment(
      String token, String id, String comment) async {
    const registerCommentMutation = '''
    mutation (\$addCommentInput: AddCommentInput!) {
      registerComment(addCommentInput: \$addCommentInput) {
        result
      }
    }
    ''';

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(document: gql(registerCommentMutation), variables: {
            'addCommentInput': {
              'id': id,
              'comment': comment,
            },
          }),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }
}
