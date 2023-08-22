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
}
