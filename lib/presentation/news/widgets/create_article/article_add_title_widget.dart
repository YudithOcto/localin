import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/create_article_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/underline_text_form_field.dart';
import 'package:provider/provider.dart';

class ArticleAddTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Subtitle(
          title: 'TITLE',
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 36.0, right: 20.0),
          child: UnderlineTextFormField(
            controller:
                Provider.of<CreateArticleProvider>(context, listen: false)
                    .titleController,
          ),
        ),
      ],
    );
  }
}
