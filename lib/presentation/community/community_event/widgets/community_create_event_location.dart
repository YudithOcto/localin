import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_place/google_place.dart';
import 'package:localin/presentation/community/community_event/provider/community_create_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/search_google_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCreateEventLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Consumer<CommunityCreateEventProvider>(
        builder: (context, provider, child) {
          return Visibility(
            visible: !provider.isOnlineEvent,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 20.0),
              physics: ClampingScrollPhysics(),
              itemCount: provider.selectedLocation.isNotEmpty ? 1 : 1,
              itemBuilder: (context, index) {
                if (provider.selectedLocation.isEmpty ||
                    provider.selectedLocation.length == index) {
                  return InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final result = await Navigator.of(context)
                          .pushNamed(SearchGooglePage.routeName);
                      if (result != null && result is AutocompletePrediction) {
                        provider.setLocation(result);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'images/add_location.svg',
                          width: 48.0,
                          height: 48.0,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'Add Location',
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.primaryBlue),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'images/add_location.svg',
                        width: 48.0,
                        height: 48.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${provider.selectedLocation}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeText.sfMediumBody,
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'City',
                              style: ThemeText.sfMediumFootnote
                                  .copyWith(color: ThemeColors.black80),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.of(context)
                              .pushNamed(SearchGooglePage.routeName);
                          if (result != null &&
                              result is AutocompletePrediction) {
                            provider.setLocation(result);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: ThemeColors.black20)),
                          child: Text(
                            'Edit',
                            style: ThemeText.sfMediumFootnote
                                .copyWith(color: ThemeColors.primaryBlue),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
