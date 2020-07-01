import 'package:flutter/material.dart';
import 'package:localin/presentation/community/provider/create/community_create_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/underline_text_form_field.dart';
import 'package:provider/provider.dart';

class CommunityAddDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Subtitle(
            title: 'DESCRIPTION',
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 36.0, right: 20.0),
            child: UnderlineTextFormField(
              maxInput: 2200,
              controller:
                  Provider.of<CommunityCreateProvider>(context, listen: false)
                      .communityDescription,
            ),
          ),
        ],
      ),
    );
  }
}
