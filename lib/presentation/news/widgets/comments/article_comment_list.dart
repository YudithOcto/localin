import 'package:flutter/material.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/single_comment_card.dart';
import 'package:provider/provider.dart';

class ArticleCommentList extends StatefulWidget {
  final ScrollController controller;
  final String articleId;
  ArticleCommentList({this.controller, this.articleId});

  @override
  _ArticleCommentListState createState() => _ArticleCommentListState();
}

class _ArticleCommentListState extends State<ArticleCommentList> {
  bool _isInit = true;
  Future getCommentList;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getCommentList = Provider.of<CommentProvider>(context, listen: false)
          .getCommentList(widget.articleId);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleCommentDetail>>(
        future: getCommentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: snapshot.hasData ? snapshot.data.length : 0,
            controller: widget.controller,
            itemBuilder: (context, index) {
              return SingleCommentCard(
                  index: index,
                  onFunction: () {
                    widget.controller.animateTo(
                        index == 2
                            ? (index * 197) - 99.toDouble()
                            : index * 250.toDouble(),
                        duration: Duration(milliseconds: 230),
                        curve: Curves.easeIn);
                  });
            },
          );
        });
  }
}
