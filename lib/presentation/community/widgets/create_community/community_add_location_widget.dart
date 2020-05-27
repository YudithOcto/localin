import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/location/search_location_response.dart';
import 'package:localin/presentation/community/provider/community_create_provider.dart';
import 'package:localin/presentation/search/search_location/search_location_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityAddLocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.of(context).pushNamed(
            SearchLocationPage.routeName,
          );
          if (result != null && result is LocationResponseDetail) {
            final provider =
                Provider.of<CommunityCreateProvider>(context, listen: false);
            if (provider.selectedLocation.contains(result.city)) {
              CustomToast.showCustomToast(
                  context, 'Already input this location');
            } else {
              provider.addLocationSelected = result.city;
            }
          }
        },
        child: Consumer<CommunityCreateProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 20.0),
              physics: ClampingScrollPhysics(),
              itemCount: provider.selectedLocation.length + 1,
              itemBuilder: (context, index) {
                if (provider.selectedLocation.isEmpty ||
                    provider.selectedLocation.length == index) {
                  return Row(
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
                              '${provider.selectedLocation[index]}',
                              maxLines: 1,
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
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: ThemeColors.black20)),
                        child: Text(
                          'Edit',
                          style: ThemeText.sfMediumFootnote
                              .copyWith(color: ThemeColors.primaryBlue),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
