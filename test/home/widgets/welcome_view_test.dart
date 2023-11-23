import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('WelcomeView', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: WelcomeView(),
        ),
      );

      final l10n = tester.element(find.byType(WelcomeView)).l10n;

      expect(find.text(l10n.initialScreenTitle), findsOneWidget);
      expect(find.byType(CTAButton), findsOneWidget);
    });

    testWidgets('calls FromWelcomeToQuestion on CTAButton tapped',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: WelcomeView(),
        ),
      );

      await tester.tap(find.byType(CTAButton));

      verify(() => homeBloc.add(const FromWelcomeToQuestion())).called(1);
    });
  });
}
