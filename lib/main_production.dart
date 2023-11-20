import 'package:authentication_repository/authentication_repository.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/bootstrap.dart';

void main() {
  bootstrap(() async {
    final authenticationRepository = AuthenticationRepository(
      firebaseAuth: firebaseAuth,
    );

    await authenticationRepository.signInAnonymously();
    await authenticationRepository.idToken.first;

    return App(
      user: authenticationRepository.user.first,
    );
  });
}
