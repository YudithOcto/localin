import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RowDanaWidget extends StatefulWidget {
  @override
  _RowDanaWidgetState createState() => _RowDanaWidgetState();
}

class _RowDanaWidgetState extends State<RowDanaWidget> {
  Future getDanaStatus;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getDanaStatus =
          Provider.of<HomeProvider>(context, listen: false).getDanaStatus();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  final oCcy = new NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0,
      decoration: BoxDecoration(
          color: ThemeColors.black100.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FutureBuilder<DanaUserAccountResponse>(
              future: getDanaStatus,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.only(left: 16.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ThemeColors.black0),
                    ),
                  );
                } else {
                  if (snapshot.hasData &&
                      snapshot.data.data != null &&
                      snapshot.data.data.maskDanaId != null) {
                    return Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 16.0, right: 8),
                          child: Image.asset(
                            'images/dana_logo_without_text.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          'Rp ${oCcy.format(snapshot.data.data.balance)}',
                          textAlign: TextAlign.center,
                          style: ThemeText.sfMediumHeadline
                              .copyWith(color: ThemeColors.black0),
                        )
                      ],
                    );
                  } else {
                    return Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 16.0, right: 19.79),
                          child: Image.asset(
                            'images/dana_logo_white.png',
                            width: 68.21,
                            height: 20,
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
                        )
                      ],
                    );
                  }
                }
              }),
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
    );
  }

  onDanaClick() async {
    final result =
        await Provider.of<HomeProvider>(context, listen: false).getDanaStatus();
    if (result.error == null) {
      await Navigator.of(context).pushNamed(WebViewPage.routeName, arguments: {
        WebViewPage.urlName: result.data.urlTopUp,
        WebViewPage.title: 'Dana',
      });
    } else {
      final authState = Provider.of<AuthProvider>(context, listen: false);
      if (authState.userModel.handphone != null &&
          authState.userModel.handphone.isNotEmpty) {
        final result = await authState
            .authenticateUserDanaAccount(authState.userModel.handphone);
        if (result.urlRedirect.isNotEmpty && !result.error) {
          final response = await Navigator.of(context)
              .pushNamed(WebViewPage.routeName, arguments: {
            WebViewPage.urlName: result.urlRedirect,
            WebViewPage.title: 'Dana',
          });
          if (response != null && response == 'success') {
            final dialogSuccess = await CustomDialog.showCustomDialogWithButton(
                context, 'Dana', 'Connect to dana success');

            if (dialogSuccess != null && dialogSuccess == 'success') {
              setState(() {
                getDanaStatus =
                    Provider.of<HomeProvider>(context, listen: false)
                        .getDanaStatus();
              });
            }
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
