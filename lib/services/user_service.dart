import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class UserService {
  static Future<QueryResult> signUp(
      String name, String lastname, String email, String password) async {
    const String signUpMutation = '''
      mutation SignUp(\$input: SignUpInput!) {
        signUp(signUpInput: \$input){
          result
          message
        }
      }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .mutate(
          MutationOptions(
            document: gql(signUpMutation),
            variables: {
              'input': {
                'names': name,
                'surnames': lastname,
                'email': email,
                'password': password,
              }
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    return result;
  }

  static Future<QueryResult> login(String email, String password) async {
    const String signInQuery = '''
      query (\$signInInput: SignInInput!) {
        signInWithEmail(signInInput: \$signInInput) {
          access_token
        }
      }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .query(
          QueryOptions(
            document: gql(signInQuery),
            variables: {
              'signInInput': {
                'email': email,
                'password': password,
              }
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    return result;
  }

  static Future<QueryResult> getProfile(String token) async {
    const String getMyProfileQuery = '''
    query {
      getMyProfile {
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
    ''';

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link = authLink.concat(HttpLink(dotenv.env['API_LINK']!));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .query(
          QueryOptions(
            document: gql(getMyProfileQuery),
          ),
        )
        .timeout(const Duration(seconds: 10));
    return result;
  }
}
