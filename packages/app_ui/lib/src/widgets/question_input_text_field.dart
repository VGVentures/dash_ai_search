import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template question_input_text_field}
/// A text field that displays an icon on the left side and an action on the
/// right.
/// {@endtemplate}
class QuestionInputTextField extends StatefulWidget {
  /// {@macro question_input_text_field}
  const QuestionInputTextField({
    required this.icon,
    required this.hint,
    required this.actionText,
    super.key,
  });

  /// The icon to display on the left side of the text field.
  final Widget icon;

  /// The hint text to display in the text field.
  final String hint;

  /// The text to display on the right side of the text field.
  final String actionText;

  @override
  State<QuestionInputTextField> createState() => _QuestionTextFieldState();
}

class _QuestionTextFieldState extends State<QuestionInputTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 659),
      child: TextField(
        controller: _controller,
        style: VertexTextStyles.body.copyWith(
          color: VertexColors.navy,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: widget.icon,
          ),
          hintText: widget.hint,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CTAButton(
              label: widget.actionText,
            ),
          ),
        ),
      ),
    );
  }
}
