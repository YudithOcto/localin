import 'package:flutter/material.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/underline_text_form_field.dart';

class InputFormWithSubtitleWidget extends StatelessWidget {
  final String subtitle;
  final TextEditingController controller;
  final Function onPressed;
  final bool isFormDisabled;
  final int maxInput;

  InputFormWithSubtitleWidget(
      {Key key,
      @required this.subtitle,
      @required this.controller,
      this.isFormDisabled = false,
      this.maxInput,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Subtitle(
            title: subtitle,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 36.0, right: 20.0),
            child: UnderlineTextFormField(
              isFormDisabled: isFormDisabled,
              maxInput: maxInput,
              onTap: onPressed,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
