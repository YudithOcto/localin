import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/home/widget/home_header_clipper.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/home/widget/home_single_services_wrapper_widget.dart';
import 'package:localin/presentation/home/widget/row_dana_widget.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HomeHeaderWidget extends StatelessWidget {
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
                  RowDanaWidget(),
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
}
