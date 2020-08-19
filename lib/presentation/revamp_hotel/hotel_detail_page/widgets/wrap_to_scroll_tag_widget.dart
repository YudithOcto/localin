import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class WrapToScrollTagWidget extends StatelessWidget {
  final int index;
  final AutoScrollController autoScrollController;
  final Widget child;

  WrapToScrollTagWidget({this.index, this.autoScrollController, this.child});

  @override
  Widget build(BuildContext context) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: autoScrollController,
      index: index,
      child: child,
      highlightColor: Colors.black.withOpacity(0.1),
    );
  }
}
