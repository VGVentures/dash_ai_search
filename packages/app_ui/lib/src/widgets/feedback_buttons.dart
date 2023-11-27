import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template feedback_buttons}
/// Like and dislike buttons. When the like button is pressed, the [onLike]
/// callback will trigger, and when the dislike button is pressed, the
/// [onDislike] will trigger.
/// {@endtemplate}
class FeedbackButtons extends StatelessWidget {
  /// {@macro feedback_buttons}
  const FeedbackButtons({
    this.onLike,
    this.onDislike,
    super.key,
  });

  /// Callback that triggers when the like button is pressed
  final VoidCallback? onLike;

  /// Callback that triggers when the dislike button is pressed
  final VoidCallback? onDislike;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Like(onPressed: onLike),
        const SizedBox(width: 16),
        _Dislike(onPressed: onDislike),
      ],
    );
  }
}

class _Like extends StatelessWidget {
  const _Like({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _FeedbackButton(
      icon: vertexImages.thumbUp.image(),
      onPressed: onPressed,
    );
  }
}

class _Dislike extends StatelessWidget {
  const _Dislike({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _FeedbackButton(
      icon: vertexImages.thumbDown.image(),
      onPressed: onPressed,
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.icon,
    this.onPressed,
  });

  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: VertexColors.white,
      radius: 32,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox.square(dimension: 33, child: icon),
      ),
    );
  }
}
