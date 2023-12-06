import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:vetplus/services/graphql_client.dart';

class ImageService {
  static Future<QueryResult> uploadImage(
      String token, File image, bool isPetImage) async {
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link = authLink.concat(HttpLink(
        '${dotenv.env['SERVER_LINK']!}/graphql',
        defaultHeaders: {'apollo-require-preflight': 'true'}));

    const String savePetImageMutation = '''
      mutation (\$savePetImageInput: SavePetImageInput!) {
        savePetImage(savePetImageInput: \$savePetImageInput) {
          result
          image
        }
      }
    ''';

    const String saveUserImageMutation = '''
    mutation (\$saveUserImageInput: SaveUserImageInput!) {
      saveUserImage(saveUserImageInput: \$saveUserImageInput) {
        result
        image
      }
    }
    ''';

    var byteData = image.readAsBytesSync();

    var multipartFile = MultipartFile.fromBytes(
      'photo',
      byteData,
      filename: '${DateTime.now().second}.jpg',
      contentType: MediaType("image", "jpg"),
    );

    final QueryResult imageResult = isPetImage
        ? await globalGraphQLClient.value
            .copyWith(link: link)
            .mutate(
              MutationOptions(
                document: gql(savePetImageMutation),
                variables: {
                  'savePetImageInput': {
                    'image': multipartFile,
                  }
                },
              ),
            )
            .timeout(const Duration(seconds: 300))
        : await globalGraphQLClient.value
            .copyWith(link: link)
            .mutate(
              MutationOptions(
                document: gql(saveUserImageMutation),
                variables: {
                  'saveUserImageInput': {
                    'image': multipartFile,
                  }
                },
              ),
            )
            .timeout(const Duration(seconds: 300));
    return imageResult;
  }
}
