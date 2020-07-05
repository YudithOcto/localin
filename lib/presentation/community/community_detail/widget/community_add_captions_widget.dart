import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_detail/provider/community_create_post_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/underline_text_form_field.dart';
import 'package:provider/provider.dart';

class CommunityAddCaptionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Subtitle(
          title: 'CAPTIONS',
        ),
        SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, bottom: 36.0),
          child: UnderlineTextFormField(
              inputAction: TextInputAction.newline,
              maxInput: 2200,
              controller: Provider.of<CommunityCreatePostProvider>(context,
                      listen: false)
                  .captionController),
        )
      ],
    );
  }
}
