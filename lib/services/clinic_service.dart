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
          ),
        )
        .timeout(const Duration(seconds: 10));
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
          ),
        )
        .timeout(const Duration(seconds: 10));
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
          ),
        )
        .timeout(const Duration(seconds: 10));
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
          ),
        )
        .timeout(const Duration(seconds: 10));
    return result;
  }
}
