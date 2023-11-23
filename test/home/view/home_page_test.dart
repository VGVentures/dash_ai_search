import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('HomePage', () {
    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        HomePage(),
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: HomeView(),
        ),
      );

      expect(find.byType(Background), findsOneWidget);
      expect(find.byType(Logo), findsOneWidget);
      expect(find.byType(WelcomeView), findsOneWidget);
    });
  });
}
