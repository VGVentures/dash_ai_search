import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('ResultsView', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: Material(child: ResultsView()),
        );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(bootstrap());

      expect(find.byType(BlueContainer), findsOneWidget);
    });

    testWidgets('animates in when enter', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardEnterStatuses = tester
          .state<ResultsViewState>(find.byType(ResultsView))
          .forwardEnterStatuses;

      expect(forwardEnterStatuses, equals([Status.thinkingToResults]));
    });

    testWidgets('animates out when exits forward', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardExitStatuses = tester
          .state<ResultsViewState>(find.byType(ResultsView))
          .forwardExitStatuses;

      expect(forwardExitStatuses, equals([Status.results]));
    });
  });
}
