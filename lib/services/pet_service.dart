import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/services/graphql_client.dart';
import 'package:vetplus/services/image_service.dart';

class PetService {
  static Future<QueryResult> getMyPets(String token) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String getMyPetsQuery = '''
    query {
      getMyPets {
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
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .query(
          QueryOptions(
            document: gql(getMyPetsQuery),
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));
    print(result);
    return result;
  }

  static Future<QueryResult> registerPet(
      File? image,
      String name,
      String gender,
      int specie,
      int breed,
      bool castrated,
      String? dob,
      String token) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    const String registerPetMutation = '''
      mutation (\$addPetInput: AddPetInput!) {
        registerPet(addPetInput: \$addPetInput) {
          result
        }
      }
    ''';

    QueryResult? imageResult = image != null
        ? await ImageService.uploadImage(token, image, true)
        : null;

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(registerPetMutation),
            variables: {
              'addPetInput': {
                "id_specie": specie,
                "id_breed": breed,
                "name": name,
                "image": imageResult != null
                    ? imageResult.data!['savePetImage']['image']
                    : null,
                "gender": gender,
                "castrated": castrated,
                "dob": dob,
                "observations": null
              }
            },
          ),
        )
        .timeout(const Duration(seconds: 300));
    return result;
  }

  static Future<QueryResult> editPetProfile(
      String token, Map<String, dynamic> values, PetModel pet) async {
    const String updatePetMutation = '''
    mutation (\$updatePetInput: UpdatePetInput!) {
      updatePet(updatePetInput: \$updatePetInput) {
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
          MutationOptions(
            document: gql(updatePetMutation),
            variables: {
              'updatePetInput': {
                'id': values.containsKey('id') ? values['id'] : pet.id,
                'id_specie': values.containsKey('id_specie')
                    ? values['id_specie']
                    : pet.idSpecie,
                'id_breed': values.containsKey('id_breed')
                    ? values['id_breed']
                    : pet.idBreed,
                'name': values.containsKey('name') ? values['name'] : pet.name,
                if (values['url_current_image'] != null)
                  'url_current_image': values['url_current_image'],
                if (values['url_new_image'] != null)
                  'url_new_image': values['url_new_image'],
                'gender': values.containsKey('gender')
                    ? values['gender']
                    : pet.gender,
                'castrated': values.containsKey('castrated')
                    ? values['castrated']
                    : pet.castrated,
                'dob': values.containsKey('dob') ? values['dob'] : pet.dob,
                'observations': values.containsKey('observations')
                    ? values['observations']
                    : pet.observations,
              }
            },
          ),
        )
        .timeout(const Duration(seconds: 300));
    if (result.hasException) {
      throw Exception();
    }
    return result;
  }
}
