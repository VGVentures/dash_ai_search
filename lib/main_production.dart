import 'dart:async';

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

      await authenticationRepository.signInAnonymously();
      await authenticationRepository.idToken.first;

      return App(
        user: await authenticationRepository.user.first,
      );
    }),
  );
}
