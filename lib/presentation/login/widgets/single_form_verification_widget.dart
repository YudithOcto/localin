import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import '../../../themes.dart';

class SingleFormVerificationWidget extends StatefulWidget {
  final int index;
  final List<FocusNode> focusNode;
  final List<TextEditingController> editingControllers;
  final ValueChanged<bool> valueChanged;
  final Color colors;
  const SingleFormVerificationWidget({
    Key key,
    this.focusNode,
    this.index,
    this.editingControllers,
    this.valueChanged,
    this.colors,
  }) : super(key: key);
  @override
  _SingleFormVerificationWidgetState createState() =>
      _SingleFormVerificationWidgetState();
}

class _SingleFormVerificationWidgetState
    extends State<SingleFormVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: Material(
        color: widget.colors,
        shape: SuperellipseShape(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: ThemeColors.black10)),
        child: Center(
          child: TextField(
            autofocus: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            onSubmitted: (value) => FocusScope.of(context)
                .requestFocus(widget.focusNode[widget.index]),
            keyboardType: TextInputType.number,
            controller: widget.editingControllers[widget.index],
            textAlign: TextAlign.center,
            focusNode: widget.focusNode[widget.index],
            onChanged: (value) {
              if (widget.index == widget.focusNode.length - 1) {
                widget.valueChanged(true);
              }
              if (widget.index < widget.focusNode.length - 1 &&
                  widget.editingControllers[widget.index].text.isNotEmpty) {
                FocusScope.of(context)
                    .requestFocus(widget.focusNode[widget.index + 1]);
                widget.editingControllers[widget.index + 1].selection =
                    TextSelection.collapsed(offset: 0);
              }
            },
            style: TextStyle(fontSize: 20.0, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                border: InputBorder.none,
                hintText: "0"),
          ),
        ),
      ),
    );
  }
}
