import 'package:flutter/material.dart';

class OptionEntryItemWrapper extends StatefulWidget {
  Widget Function(BuildContext, bool) builder;

  OptionEntryItemWrapper({super.key, required this.builder});

  @override
  _OptionEntryItemWrapper createState() => _OptionEntryItemWrapper();
}

class _OptionEntryItemWrapper extends State<OptionEntryItemWrapper> {
  bool focused = false;
  FocusNode? node;

  void focus_listener() {
    if (mounted && node != null) {
      setState(() {
        focused = node!.hasFocus;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    node?.removeListener(focus_listener);
    node = Focus.of(context);
    node?.addListener(focus_listener);
  }

  @override
  void dispose() {
    node?.removeListener(focus_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, focused);
  }
}