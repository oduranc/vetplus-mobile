import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class AppointmentsService {
  static Future<QueryResult> scheduleAppointment(
    String token,
    String vetId,
    String petId,
    List<String?> services,
    String clinicId,
    String startAt,
  ) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String scheduleAppointmentMutation = '''
    mutation (\$scheduleAppointmentInput: ScheduleAppointmentInput!) {
      scheduleAppoinment(scheduleAppointmentInput: \$scheduleAppointmentInput) {
        result
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(scheduleAppointmentMutation),
            variables: {
              "scheduleAppointmentInput": {
                "id_veterinarian": vetId,
                "id_pet": petId,
                "services": services,
                "id_clinic": clinicId,
                "start_at": startAt,
                "end_at": null,
              }
            },
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> getAppointments(
    String token,
  ) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String getAppointmentsQuery = '''
    query (\$filterAppointmentBySSInput: FilterAppointmentBySSInput!) {
      getAppointmentDetailAllRoles(
        filterAppointmentBySSInput: \$filterAppointmentBySSInput
      ) {
        start_at
        end_at
        id
        id_owner
        id_veterinarian
        id_pet
        services
        id_clinic
        observations
        appointment_status
        state
        created_at
        updated_at
        status
        Clinic {
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
        }
        Pet {
          id
          id_owner
          id_specie
          id_breed
          name
          image
          gender
          castrated
          dob
          observations
          created_at
          updated_at
          status
        }
        Veterinarian {
          id
          names
          surnames
          email
          provider
          document
          address
          telephone_number
          image
          role
          created_at
          updated_at
          status
        }
        Owner {
          id
          names
          surnames
          email
          provider
          document
          address
          telephone_number
          image
          role
          created_at
          updated_at
          status
        }
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(getAppointmentsQuery),
            variables: {
              "filterAppointmentBySSInput": {
                "state": null,
                "appointment_status": null
              }
            },
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> getPetAppointments(
      String token, String petId) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String getPetAppointmentsQuery = '''
    query (\$filterAppointmentByIdInput: FilterAppointmentByIdInput!) {
      getAppointmentPerPet(
        filterAppointmentByIdInput: \$filterAppointmentByIdInput
      ) {
        start_at
        end_at
        id
        id_owner
        id_veterinarian
        id_pet
        services
        id_clinic
        observations
        appointment_status
        state
        created_at
        updated_at
        status
        Clinic {
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
        }
        Pet {
          id
          id_owner
          id_specie
          id_breed
          name
          image
          gender
          castrated
          dob
          observations
          created_at
          updated_at
          status
        }
        Veterinarian {
          id
          names
          surnames
          email
          provider
          document
          address
          telephone_number
          image
          role
          created_at
          updated_at
          status
        }
        Owner {
          id
          names
          surnames
          email
          provider
          document
          address
          telephone_number
          image
          role
          created_at
          updated_at
          status
        }
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(getPetAppointmentsQuery),
            variables: {
              "filterAppointmentByIdInput": {"id": petId, "state": null}
            },
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }
}
