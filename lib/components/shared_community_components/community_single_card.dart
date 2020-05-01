import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/pages/community_detail_page.dart';
import '../../text_themes.dart';
import '../../themes.dart';

class CommunitySingleCard extends StatefulWidget {
  final int index;
  final CommunityDetail model;

  CommunitySingleCard({this.index, this.model});

  @override
  _CommunitySingleCardState createState() => _CommunitySingleCardState();
}

class _CommunitySingleCardState extends State<CommunitySingleCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context)
            .pushNamed(CommunityDetailPage.routeName, arguments: {
          CommunityDetailPage.communitySlug: widget.model.slug,
        });

        if (result == 'refresh') {
          setState(() {
            widget.model.isJoin = !widget.model.isJoin;
          });
        }
      },
      child: Card(
        elevation: 1.0,
        color: ThemeColors.black0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget?.model?.logoUrl,
              errorWidget: (context, _, child) => Container(
                height: 135.0,
                width: 239.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
              ),
              placeholder: (context, image) => Container(
                height: 135.0,
                width: 239.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
              ),
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 135.0,
                  width: 239.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                );
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${widget.model.categoryName.toUpperCase() ?? ''}',
                style: ThemeText.sfSemiBoldFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${widget.model.name ?? ''}',
                style: ThemeText.rodinaTitle3,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${widget.model.totalMember ?? '0'} ${widget.model.totalMember.isPluralWord ? 'members' : 'Member'}',
                style:
                    ThemeText.sfMediumBody.copyWith(color: ThemeColors.black80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on int {
  bool get isPluralWord {
    if (this == null || this == 0 || this == 1) return false;
    return true;
  }
}
