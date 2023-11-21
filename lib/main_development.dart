import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/bootstrap.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp();

  unawaited(
    bootstrap((firebaseAuth) async {
      final authenticationRepository = AuthenticationRepository(
        firebaseAuth: firebaseAuth,
      );

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:8080',
        idTokenStream: authenticationRepository.idToken,
        refreshIdToken: authenticationRepository.refreshIdToken,
      );

      await authenticationRepository.signInAnonymously();
      await authenticationRepository.idToken.first;

      return App(
        apiClient: apiClient,
        user: await authenticationRepository.user.first,
      );
    }),
  );
}
