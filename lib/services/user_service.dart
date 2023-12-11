import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/models/user_model.dart';
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
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .query(QueryOptions(document: gql(googleLoginQuery)))
        .timeout(const Duration(seconds: 300));

    print(result);
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
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql'));

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
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> signUp(int verificationCode, String room) async {
    const String signUpMutations = '''
    mutation (\$verificationCodeInput: VerificationCodeInput!) {
      signUp(verificationCodeInput: \$verificationCodeInput) {
        result
        message
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .mutate(
          MutationOptions(
            document: gql(signUpMutations),
            variables: {
              'verificationCodeInput': {
                'verificationCode': verificationCode,
                'room': room,
              },
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> signUpVerificationCode(
      String name, String lastname, String email, String password) async {
    const String signUpMutation = '''
    mutation (\$signUpInput: SignUpInput!) {
      signUpVerificationCode(signUpInput: \$signUpInput) {
        room
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .mutate(
          MutationOptions(
            document: gql(signUpMutation),
            variables: {
              'signUpInput': {
                'names': name,
                'surnames': lastname,
                'email': email,
                'password': password,
              }
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

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
        .timeout(const Duration(seconds: 300));
    print(result);

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
        User_Fmc {
          id_user
          token_fmc
        }
        VeterinariaSpecialties {
          specialties
        }
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
            document: gql(getMyProfileQuery),
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> registerSpecialty(
      String token, String? specialty) async {
    const String registerSpecialtyMutation = '''
    mutation (\$addSpecialtyInput: AddSpecialtyInput!) {
      registerSpecialty(addSpecialtyInput: \$addSpecialtyInput) {
        result
      }
    }
    ''';

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link =
        authLink.concat(HttpLink('${dotenv.env['SERVER_LINK']!}/graphql/'));

    final QueryResult result = await globalGraphQLClient.value
        .copyWith(link: link)
        .mutate(
          MutationOptions(
            document: gql(registerSpecialtyMutation),
            variables: {
              'addSpecialtyInput': {
                'specialties': specialty,
              }
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

    print(result);
    return result;
  }

  static Future<QueryResult> editProfile(
      String token, Map<String, String?> values, UserModel user) async {
    const String updateProfileMutation = '''
    mutation (\$updateUserInput: UpdateUserInput!) {
      updateUser(updateUserInput: \$updateUserInput) {
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
            document: gql(updateProfileMutation),
            variables: {
              'updateUserInput': {
                'names':
                    values.containsKey('names') ? values['names'] : user.names,
                'surnames': values.containsKey('surnames')
                    ? values['surnames']
                    : user.surnames,
                'document': values.containsKey('document')
                    ? values['document']
                    : user.document,
                'address': values.containsKey('address')
                    ? values['address']
                    : user.address,
                'telephone_number': values.containsKey('telephone_number')
                    ? values['telephone_number']
                    : user.telephoneNumber,
                'image':
                    values.containsKey('image') ? values['image'] : user.image,
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

  static Future<QueryResult> recoverPasswordVerificationCode(
      String email) async {
    const String recoverMutation = '''
    mutation (\$recoveryCredentialsInput: RecoveryCredentialsInput!) {
      recoveryPasswordSendVerificationCode(
        recoveryCredentialsInput: \$recoveryCredentialsInput
      ) {
        room
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .mutate(
          MutationOptions(
            document: gql(recoverMutation),
            variables: {
              'recoveryCredentialsInput': {
                'email': email,
              }
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }

  static Future<QueryResult> recoverPassword(
      int verificationCode, String room) async {
    const String recoverMutation = '''
    mutation (\$verificationCodeInput: VerificationCodeInput!) {
      recoveryAccount(verificationCodeInput: \$verificationCodeInput) {
        access_token
      }
    }
    ''';

    final QueryResult result = await globalGraphQLClient.value
        .mutate(
          MutationOptions(
            document: gql(recoverMutation),
            variables: {
              'verificationCodeInput': {
                'verificationCode': verificationCode,
                'room': room,
              },
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        )
        .timeout(const Duration(seconds: 300));

    return result;
  }
}
