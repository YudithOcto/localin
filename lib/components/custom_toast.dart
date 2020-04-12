import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localin/themes.dart';

import '../text_themes.dart';

class CustomToast {
  static showCustomToast(BuildContext context, String message,
      {AlignmentGeometry alignment = Alignment.bottomCenter}) {
    showToast('$message',
        context: context,
        position: StyledToastPosition(offset: 70.0, align: alignment),
        textStyle:
            ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.red80),
        backgroundColor: ThemeColors.red10);
  }
}
