import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template question_input_text_field}
/// A text field that displays an icon on the left side and an action on the
/// right.
/// {@endtemplate}
class QuestionInputTextField extends StatefulWidget {
  /// {@macro question_input_text_field}
  const QuestionInputTextField({
    required this.hint,
    required this.actionText,
    required this.onTextUpdated,
    required this.onActionPressed,
    this.shouldDisplayClearTextButton = false,
    this.shouldAnimate = false,
    this.text,
    super.key,
  });

  /// The hint text to display in the text field.
  final String hint;

  /// The text to display on the right side of the text field.
  final String actionText;

  /// Function called when text is updated
  final ValueChanged<String> onTextUpdated;

  /// Function called when the action widget is pressed
  final VoidCallback onActionPressed;

  /// Initial text displayed in the text field
  final String? text;

  /// Set to `true` when instead of showing the action, you expect a button
  /// that clears the text field
  final bool shouldDisplayClearTextButton;

  /// It indicates if the text field will have animation or not.
  /// Defaults to `false`
  final bool shouldAnimate;

  /// Key to find the animated builder for the text field. Used for testing.
  @visibleForTesting
  static const Key textFieldAnimatedBuilderKey =
      Key('text_field_animated_builder');

  /// Key to find the animated builder for the hint. Used for testing.
  @visibleForTesting
  static const Key hintAnimatedBuilderKey = Key('hint_animated_builder');

  @override
  State<QuestionInputTextField> createState() => _QuestionTextFieldState();
}

class _QuestionTextFieldState extends State<QuestionInputTextField>
    with TickerProviderStateMixin {
  late final TextEditingController _controller;
  late final AnimationController _hintAnimationController;
  late final AnimationController _textFieldAnimationController;

  late Animation<double> _textFieldAnimationSize;
  late Animation<double> _hintAnimationPadding;
  static const _width = 659.0;

  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(() {
      widget.onTextUpdated(_controller.text);
    });
    _textFieldAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _hintAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _hintAnimationPadding =
        Tween<double>(begin: 16, end: 600).animate(_hintAnimationController);
    _textFieldAnimationSize = Tween<double>(begin: _width, end: 0).animate(
      CurvedAnimation(
        parent: _textFieldAnimationController,
        curve: Curves.decelerate,
      ),
    );

    if (widget.shouldAnimate) {
      _textFieldAnimationController
        ..forward()
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _hintAnimationController.forward();
          }
        });
    }

    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _textFieldAnimationController.dispose();
    _hintAnimationController.dispose();
    _focus.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(
        color: VertexColors.lightGrey,
        width: 2,
      ),
    );
    return Container(
      constraints: const BoxConstraints(maxWidth: _width, maxHeight: 100),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            child: TextField(
              focusNode: _focus,
              controller: _controller,
              style: textTheme.bodyMedium?.copyWith(
                color: VertexColors.flutterNavy,
              ),
              autofillHints: null,
              onSubmitted: (_) => widget.onActionPressed(),
              decoration: InputDecoration(
                filled: true,
                border: MaterialStateOutlineInputBorder.resolveWith((states) {
                  if (states.contains(MaterialState.focused)) {
                    return baseBorder.copyWith(
                      borderSide: baseBorder.borderSide.copyWith(
                        color: VertexColors.googleBlue,
                      ),
                    );
                  }
                  return baseBorder;
                }),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: vertexIcons.stars.image(
                    color: _controller.text.isNotEmpty
                        ? VertexColors.googleBlue
                        : VertexColors.mediumGrey,
                  ),
                ),
                hintText: widget.hint,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: widget.shouldDisplayClearTextButton
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                          },
                          icon: const Icon(Icons.close),
                        )
                      : PrimaryCTA(
                          label: widget.actionText,
                          onPressed: () => widget.onActionPressed(),
                        ),
                ),
              ),
            ),
          ),
          if (widget.shouldAnimate) ...[
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedBuilder(
                key: QuestionInputTextField.textFieldAnimatedBuilderKey,
                animation: _textFieldAnimationController,
                builder: (_, __) => Container(
                  color: VertexColors.white,
                  width: _textFieldAnimationSize.value,
                ),
              ),
            ),
            Align(
              child: AnimatedBuilder(
                key: QuestionInputTextField.hintAnimatedBuilderKey,
                animation: _hintAnimationController,
                builder: (_, __) => Container(
                  color: VertexColors.white,
                  margin: EdgeInsets.only(
                    top: 32,
                    bottom: 32,
                    right: 120,
                    left: _hintAnimationPadding.value,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
