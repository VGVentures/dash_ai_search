import 'dart:ui' as ui show Image;

import 'package:app_ui/app_ui.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class __MockImages extends Mock implements Images {}

void main() {
  group('AnimatedSprite', () {
    late Images images;
    late ui.Image image;

    setUp(() async {
      images = __MockImages();
      Flame.images = images;
      image = await createTestImage(height: 10, width: 10);
    });

    setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

    testWidgets('renders AppCircularProgressIndicator when loading asset',
        (tester) async {
      await tester.pumpWidget(
        AnimatedSprite(
          sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
        ),
      );
      expect(find.byType(AppCircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'does not render AppCircularProgressIndicator'
        ' when loading asset and showLoadingIndicator is false',
        (tester) async {
      await tester.pumpWidget(
        AnimatedSprite(
          sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
          showLoadingIndicator: false,
        ),
      );
      expect(find.byType(AppCircularProgressIndicator), findsNothing);
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (loop)',
        (tester) async {
      await tester.runAsync(() async {
        final images = __MockImages();
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedSprite(
                sprites:
                    Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
              ),
            ),
          ),
        );
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
      });
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (oneTime)',
        (tester) async {
      await tester.runAsync(() async {
        final images = __MockImages();
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedSprite(
                sprites:
                    Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
                mode: AnimationMode.oneTime,
              ),
            ),
          ),
        );
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
      });
    });

    testWidgets('renders animation 2 times', (tester) async {
      await tester.runAsync(() async {
        final images = __MockImages();
        var asset = 'test.png';
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (_, setState) {
                return Scaffold(
                  body: AnimatedSprite(
                    sprites: Sprites(asset: asset, size: Size(1, 1), frames: 1),
                    mode: AnimationMode.oneTime,
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        asset = 'test2.png';
                      });
                    },
                  ),
                );
              },
            ),
          ),
        );
        verify(() => images.load('test.png')).called(1);
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
        verify(() => images.load('test2.png')).called(1);
      });
    });
  });
}
