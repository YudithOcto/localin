import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/home/widget/home_header_clipper.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HomeHeaderWidget extends StatefulWidget {
  @override
  _HomeHeaderWidgetState createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipPath(
              clipper: HomeHeaderClipper(),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1F75E1), Color(0xFF094AAC)])),
              ),
            ),
            Positioned(
              top: 26.36 + MediaQuery.of(context).padding.top,
              left: 20.0,
              right: 20.0,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'images/localin_logo.png',
                        fit: BoxFit.cover,
                        height: 32.99,
                        width: 119.72,
                      ),
                      CachedNetworkImage(
                        imageUrl:
                            Provider.of<AuthProvider>(context, listen: false)
                                ?.userModel
                                ?.imageProfile,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                                image: DecorationImage(
                                  image: imageProvider,
                                )),
                          );
                        },
                        placeholder: (context, url) => Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ThemeColors.black80,
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                        errorWidget: (context, url, child) => Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ThemeColors.black80,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Icon(Icons.person),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 64.0,
                    decoration: BoxDecoration(
                        color: ThemeColors.black100.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 16.0, right: 19.79),
                              child: Image.asset(
                                'images/dana_logo_white.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            InkWell(
                              onTap: onDanaClick,
                              child: Container(
                                height: 28.0,
                                width: 47.0,
                                alignment: FractionalOffset.center,
                                decoration: BoxDecoration(
                                    color: ThemeColors.yellow,
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Text(
                                  'ADD',
                                  textAlign: TextAlign.center,
                                  style: ThemeText.sfSemiBoldFootnote,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            height: 32.0,
                            child: Dash(
                              direction: Axis.vertical,
                              length: 32.0,
                              dashThickness: 1.5,
                              dashColor: ThemeColors.black20,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SvgPicture.asset(
                                'images/point_icon.svg',
                                width: 24.0,
                                height: 24.0,
                              ),
                            ),
                            Consumer<AuthProvider>(
                              builder: (context, provider, child) => Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  '${provider.userModel.points} Point',
                                  style: ThemeText.sfRegularHeadline
                                      .copyWith(color: ThemeColors.black0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        HomeSingleServicesWrapperWidget(
                          serviceIcon: 'home_service_stay_icon.svg',
                          serviceName: 'STAY',
                          onPressed: () {
                            Provider.of<HomeProvider>(context, listen: false)
                                .setRoomPage(true);
                          },
                        ),
                        HomeSingleServicesWrapperWidget(
                          serviceIcon: 'home_service_eat_icon.svg',
                          serviceName: 'EAT',
                          onPressed: () => Navigator.of(context)
                              .pushNamed(EmptyPage.routeName),
                        ),
                        HomeSingleServicesWrapperWidget(
                          serviceIcon: 'home_service_attraction_icon.svg',
                          serviceName: 'ATTRACT',
                          onPressed: () => Navigator.of(context)
                              .pushNamed(EmptyPage.routeName),
                        ),
                        HomeSingleServicesWrapperWidget(
                          serviceIcon: 'home_service_ticket_icon.svg',
                          serviceName: 'EVENT',
                          onPressed: () => Navigator.of(context)
                              .pushNamed(EmptyPage.routeName),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  onDanaClick() async {
    final result =
        await Provider.of<HomeProvider>(context, listen: false).getDanaStatus();
    if (!result.error) {
      await Navigator.of(context).pushNamed(WebViewPage.routeName, arguments: {
        WebViewPage.urlName: result.data.urlTopUp,
      });
    } else {
      final authState = Provider.of<AuthProvider>(context, listen: false);
      if (authState.userModel.handphone != null &&
          authState.userModel.handphone.isNotEmpty) {
        final result = await authState
            .authenticateUserDanaAccount(authState.userModel.handphone);
        if (result.urlRedirect.isNotEmpty && !result.error) {
          final response = await Navigator.of(context).pushNamed(
              WebViewPage.routeName,
              arguments: {WebViewPage.urlName: result.urlRedirect});
          if (response != null && response == 'success') {
            await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('DANA'),
                    content: Text(
                      'Connect to dana success',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        color: ThemeColors.primaryBlue,
                        onPressed: () => Navigator.of(context).pop('success'),
                        child: Text(
                          'Ok',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  );
                });
          }
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('No Phone number on your account'),
          duration: Duration(milliseconds: 1500),
        ));
      }
    }
  }
}

class HomeSingleServicesWrapperWidget extends StatelessWidget {
  final String serviceIcon;
  final String serviceName;
  final Function onPressed;

  HomeSingleServicesWrapperWidget(
      {this.serviceIcon, this.serviceName, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'images/$serviceIcon',
            width: 62.0,
            height: 62.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '$serviceName',
            style: ThemeText.sfSemiBoldCaption.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
