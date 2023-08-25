import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/services/graphql_client.dart';

class UserService {
  static Future<QueryResult> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    const String googleLoginQuery = '''
    query {
      googleLogin {
        access_token
      }
    }
    ''';

    final AuthLink authLink =
        AuthLink(getToken: () async => 'Bearer ${googleAuth!.idToken}');
    final Link link = authLink.concat(HttpLink(dotenv.env['API_LINK']!));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .query(QueryOptions(document: gql(googleLoginQuery)))
        .timeout(const Duration(seconds: 10));

    return result;
  }

  static Future<QueryResult> signUpWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    const String googleRegisterMutation = '''
    mutation (\$signUpInput: SignUpInput!) {
      googleRegister(signUpInput: \$signUpInput) {
        access_token
      }
    }
    ''';

    final AuthLink authLink =
        AuthLink(getToken: () async => 'Bearer ${googleAuth!.idToken}');
    final Link link = authLink.concat(HttpLink(dotenv.env['API_LINK']!));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(googleRegisterMutation),
            variables: {
              'signUpInput': {
                'names': googleUser!.displayName,
                'email': googleUser.email,
                'provider': 'GOOGLE',
              }
            },
          ),
        )
        .timeout(const Duration(seconds: 10));

    return result;
  }

  static Future<QueryResult> signUpWithEmail(
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

  static Future<QueryResult> loginWithEmail(
      String email, String password) async {
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
