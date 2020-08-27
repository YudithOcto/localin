import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsVideoPlayer extends StatefulWidget {
  final String youtubeUrl;
  NewsVideoPlayer({this.youtubeUrl});

  @override
  _NewsVideoPlayerState createState() => _NewsVideoPlayerState();
}

class _NewsVideoPlayerState extends State<NewsVideoPlayer> {
  @override
  void deactivate() {
    Provider.of<NewsDetailProvider>(context, listen: false).controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller:
            Provider.of<NewsDetailProvider>(context, listen: false).controller,
      ),
      builder: (context, player) {
        return Align(
          child: FittedBox(
            fit: BoxFit.cover,
            child: player,
          ),
        );
      },
    );
  }
}
