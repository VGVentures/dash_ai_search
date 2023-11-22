import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Background', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Background(),
      );

      expect(find.byType(Circle), findsNWidgets(6));
    });
  });
}
