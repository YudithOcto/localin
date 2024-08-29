import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/model/location/search_location_response.dart';
import 'package:localin/presentation/search/provider/search_location_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SearchLocationPage extends StatelessWidget {
  static const routeName = 'SearchLocationPage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchLocationProvider>(
      create: (_) =>
          SearchLocationProvider(analyticsService: locator<AnalyticsService>()),
      child: SearchLocationListWidget(),
    );
  }
}

class SearchLocationListWidget extends StatefulWidget {
  @override
  _SearchLocationListWidgetState createState() =>
      _SearchLocationListWidgetState();
}

class _SearchLocationListWidgetState extends State<SearchLocationListWidget> {
  bool _isInit = true;
  final ScrollController _scrollController = ScrollController();
  var streamLocation;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _scrollController.addListener(_getLocationData);
      streamLocation =
          Provider.of<SearchLocationProvider>(context, listen: false)
              .locationStream;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _getLocationData() {
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent * 0.95) {
      Provider.of<SearchLocationProvider>(context, listen: false)
          .loadLocationData(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        titleSpacing: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Container(
          height: 43.0,
          margin: EdgeInsets.only(right: 20.0),
          child: Consumer<SearchLocationProvider>(
            builder: (context, provider, child) {
              return TextFormField(
                controller: provider.locationController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ThemeColors.black10,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(color: ThemeColors.black0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(color: ThemeColors.black0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(color: ThemeColors.black0)),
                  hintText: 'Search Location',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black60),
                ),
              );
            },
          ),
        ),
      ),
      body: StreamBuilder<locationState>(
        stream: streamLocation,
        builder: (context, snapshot) {
          final provider =
              Provider.of<SearchLocationProvider>(context, listen: false);
          if (snapshot.data == locationState.loading && provider.offset <= 1) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (provider.searchList.isEmpty) {
              return Consumer<AuthProvider>(
                builder: (_, user, __) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        LocationResponseDetail locationDetail =
                            LocationResponseDetail();
                        locationDetail.id = 'idUser';
                        locationDetail.city = user.userModel.address?.titleCase;
                        locationDetail.province = '';
                        Navigator.of(context).pop(locationDetail);
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'images/add_location.svg',
                          width: 48.0,
                          height: 48.0,
                        ),
                        title: Text(
                          user.userModel.address.titleCase,
                          style: ThemeText.rodinaHeadline,
                        ),
                        subtitle: Text(
                          'City',
                          style: ThemeText.sfMediumFootnote
                              .copyWith(color: ThemeColors.black80),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 20.0),
                physics: ClampingScrollPhysics(),
                itemCount: provider.searchList.length + 1,
                itemBuilder: (context, index) {
                  if (provider.searchList.length == 0) {
                    return Consumer<AuthProvider>(
                      builder: (context, user, child) {
                        return ListTile(
                          leading: SvgPicture.asset(
                            'images/add_location.svg',
                            width: 48.0,
                            height: 48.0,
                          ),
                          title: Text(
                            user.userModel.address,
                            style: ThemeText.rodinaHeadline,
                          ),
                          subtitle: Text(
                            'City',
                            style: ThemeText.sfMediumFootnote
                                .copyWith(color: ThemeColors.black80),
                          ),
                        );
                      },
                    );
                  } else if (index < provider.searchList.length) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pop(provider.searchList[index]);
                      },
                      leading: SvgPicture.asset(
                        'images/add_location.svg',
                        width: 48.0,
                        height: 48.0,
                      ),
                      title: Text(
                        provider.searchList[index].city,
                        style: ThemeText.rodinaHeadline,
                      ),
                      subtitle: Text(
                        'City',
                        style: ThemeText.sfMediumFootnote
                            .copyWith(color: ThemeColors.black80),
                      ),
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
            }
          }
        },
      ),
    );
  }
}

extension on String {
  String get titleCase {
    return this
        .toLowerCase()
        .split(' ')
        .map((e) => e.substring(0, 1).toUpperCase() + e.substring(1, e.length))
        .join(' ');
  }
}
