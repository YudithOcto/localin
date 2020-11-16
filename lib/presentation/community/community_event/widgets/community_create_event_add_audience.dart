import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/underline_text_form_field.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CreateCommunityEventAddAudience extends StatelessWidget {
  final TextEditingController controller;
  final List<String> defaultAudienceNumber;
  final Function(String) onTap;

  CreateCommunityEventAddAudience(
      {this.controller, @required this.defaultAudienceNumber, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Subtitle(
            title: 'audience',
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Maximum number of audience for this event. You can enter manually '
            'the number of use our shortcut option below.',
            style: ThemeText.sfRegularFootnote
                .copyWith(color: ThemeColors.black80),
          ),
          UnderlineTextFormField(
            onChanged: (v) {},
            controller: controller,
            inputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            inputType: TextInputType.number,
            inputAction: TextInputAction.done,
          ),
          SizedBox(
            height: 12.0,
          ),
          Row(
            children: List.generate(
              4,
              (index) => InkWell(
                onTap: () => onTap(defaultAudienceNumber[index]),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: ThemeColors.black40),
                  ),
                  child: Text(
                    defaultAudienceNumber[index],
                    style: ThemeText.sfSemiBoldFootnote,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
