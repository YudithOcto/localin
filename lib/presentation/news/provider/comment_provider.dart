import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_comment_base_response.dart';

class CommentProvider with ChangeNotifier {
  final Repository _repository = Repository();

  Future<List<ArticleCommentDetail>> getCommentList(String articleId) async {
    final response = await _repository.getArticleComment(articleId);
    return response.comments;
  }
}
