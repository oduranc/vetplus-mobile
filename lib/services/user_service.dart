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
}
