import 'package:flutter/material.dart';

extension GlobalKeyExtensionMethods on GlobalKey {
  Size? getWidgetSize() {
    final context = currentContext;
    if (context == null) return null;
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size;
  }
}
