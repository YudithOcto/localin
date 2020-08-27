import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsDetailProvider with ChangeNotifier {
  final Repository _repository = Repository();
  YoutubePlayerController controller;

  NewsDetailProvider({String url}) {
    print(url);
    if (url != null && url.isNotEmpty) {
      controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url),
        flags: YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
  }

  Future<ArticleBaseResponse> likeArticle(String articleId) async {
    final response = await _repository.likeArticle(articleId);
    return response;
  }

  Future<ArticleBaseResponse> bookmarkArticle(String articleId) async {
    final response = await _repository.bookmarkArticle(articleId);
    return response;
  }

  Future<List<ArticleDetail>> getRelatedArticle(String articleId) async {
    final response = await _repository.getRelatedArticle(articleId);
    if (response != null && response.error == null) {
      return response.data;
    }
    return [];
  }

  ArticleDetail _articleDetail;
  ArticleDetail get articleDetail => _articleDetail;

  Future<ArticleBaseResponse> getArticleDetail(String articleId) async {
    final result = await _repository.getArticleDetail(articleId);
    if (result != null && result.detail != null) {
      _articleDetail = result.detail;
      notifyListeners();
      return result;
    } else {
      return null;
    }
  }

  bool _isNewsBookmarkChanged;
  bool get isNewsBookmarkChange => _isNewsBookmarkChanged;
  set changeBookmark(bool value) {
    _isNewsBookmarkChanged = value;
    notifyListeners();
  }
}
