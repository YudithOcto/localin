import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_discover_subtitle_widget.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_other_row_widget.dart';
import 'package:localin/presentation/community/provider/community_category_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCategoryOtherList extends StatefulWidget {
  @override
  _CommunityCategoryOtherListState createState() =>
      _CommunityCategoryOtherListState();
}

class _CommunityCategoryOtherListState
    extends State<CommunityCategoryOtherList> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CommunityCategoryProvider>(context, listen: false)
          .getCommunityCategory();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CommunityDiscoverSubtitleWidget(
            svgAsset: 'images/star_orange.svg',
            title: 'Others',
          ),
        ),
        Consumer<CommunityCategoryProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<othersCommunityState>(
                stream: provider.streamOther,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      provider.page <= 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: provider.otherCommunity.length + 1,
                    itemBuilder: (context, index) {
                      if (snapshot.data == othersCommunityState.empty) {
                        return Container();
                      } else if (index < provider.otherCommunity.length) {
                        final item = provider.otherCommunity[index];
                        return CommunityOtherRowWidget(
                          detail: item,
                        );
                      } else if (provider.canLoadMore) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                });
          },
        ),
      ],
    );
  }
}
