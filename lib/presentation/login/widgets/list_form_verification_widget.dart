import 'package:flutter/material.dart';
import 'package:localin/presentation/login/widgets/single_form_verification_widget.dart';
import 'package:localin/themes.dart';

class ListFormVerificationWidget extends StatefulWidget {
  final int length;
  final ValueChanged<bool> valueChanged;
  final Color color;

  const ListFormVerificationWidget(
      {Key key,
      this.length,
      this.valueChanged,
      this.color = ThemeColors.black0})
      : super(key: key);

  @override
  _ListFormVerificationWidgetState createState() =>
      _ListFormVerificationWidgetState();
}

class _ListFormVerificationWidgetState
    extends State<ListFormVerificationWidget> {
  final nodes = List<FocusNode>();
  final inputs = List<SingleFormVerificationWidget>();
  final List<TextEditingController> editingControllers =
      List<TextEditingController>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.length; i++) {
      nodes.add(FocusNode());
      editingControllers.add(TextEditingController(text: ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(widget.length, (index) {
        return SingleFormVerificationWidget(
          index: index,
          valueChanged: (value) {
            widget.valueChanged(value);
          },
          colors: widget.color,
          editingControllers: editingControllers,
          focusNode: nodes,
        );
      }),
    );
  }
}
