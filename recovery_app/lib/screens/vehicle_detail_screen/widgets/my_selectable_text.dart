import 'package:flutter/material.dart';

class MySelectableText extends StatefulWidget {
  final String? dataDetails;
  const MySelectableText({
    super.key,
    required this.dataDetails,
  });
  @override
  _MySelectableTextState createState() => _MySelectableTextState();
}

class _MySelectableTextState extends State<MySelectableText> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Text is selected, do nothing
    } else {
      // Text is deselected, remove the selection
      _removeSelection();
    }
  }

  void _removeSelection() {
    // Clear the selection by setting the focus to an empty focus node
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _removeSelection,
      child: SelectableText(
        widget.dataDetails as String,
        focusNode: _focusNode,
      ),
    );
  }
}
