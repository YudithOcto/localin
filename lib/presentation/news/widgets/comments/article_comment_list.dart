import 'package:flutter/material.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/presentation/shared_widgets/empty_article.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CommentProvider>(context, listen: false)
          .getCommentList(widget.articleId);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<commentState>(
            stream: provider.state,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  provider.commentRequestOffset <= 1) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: provider.articleCommentList.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.hasData && snapshot.data == commentState.empty) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      child: EmptyArticle(
                        title: 'No Comments yet in this post',
                        message: 'Be the one to comment first!',
                        isShowButton: false,
                      ),
                    );
                  } else if (index < provider.articleCommentList.length) {
                    return ParentCommentCard(
                      commentDetail: provider.articleCommentList[index],
                      index: index,
                    );
                  } else if (provider.isCanLoadMoreComment) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            });
      },
    );
  }
}
