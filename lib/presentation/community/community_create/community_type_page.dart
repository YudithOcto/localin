import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/presentation/community/community_create/widgets/community_confirmation_details_widget.dart';
import 'package:localin/presentation/community/provider/create/community_type_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CommunityTypePage extends StatelessWidget {
  static const routeName = 'CommunityType';
  static const requestModel = 'RequestModel';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityTypeProvider>(
      create: (_) => CommunityTypeProvider(),
      child: CommunityTypeCreateContent(),
    );
  }
}

class CommunityTypeCreateContent extends StatefulWidget {
  @override
  _CommunityTypeCreateContentState createState() =>
      _CommunityTypeCreateContentState();
}

class _CommunityTypeCreateContentState
    extends State<CommunityTypeCreateContent> {
  PanelController _pc = new PanelController();

  createCommunity({@required String type}) async {
    final provider = Provider.of<CommunityTypeProvider>(context, listen: false);
    provider.setCommunityType(type);
    final result = await CustomDialog.showCustomDialogWithMultipleButton(
        context,
        title: 'Confirm Membership',
        message: 'I\'m sure to process this payment',
        cancelText: 'Cancel',
        onCancel: () => Navigator.of(context).pop(),
        okCallback: () => Navigator.of(context).pop(true),
        okText: 'Yes');
    if (result != null && result) {
      provider.showPanel(true);
      provider.setType(type);
      _pc.animatePanelToPosition(1.0, duration: Duration(milliseconds: 350));
    }
  }

  _onBackPressed() {
    if (_pc.panelPosition == 1.0) {
      _pc.animatePanelToPosition(0.0, duration: Duration(milliseconds: 350));
      Provider.of<CommunityTypeProvider>(context, listen: false)
          .showPanel(false);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onBackPressed(),
      child: Scaffold(
        bottomNavigationBar: StreamBuilder<bool>(
            stream: Provider.of<CommunityTypeProvider>(context, listen: false)
                .panelStream,
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.data == null ? true : !snapshot.data,
                child: RaisedButton(
                  onPressed: () => createCommunity(type: 'paid'),
                  color: ThemeColors.black0,
                  elevation: 0.0,
                  child: Text(
                    'Start paid community',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.primaryBlue),
                  ),
                ),
              );
            }),
        body: FutureBuilder<String>(
            future: Provider.of<CommunityTypeProvider>(context, listen: false)
                .getCommunityPrice(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final routeArgs = ModalRoute.of(context).settings.arguments
                    as Map<String, dynamic>;
                CommunityCreateRequestModel model =
                    routeArgs[CommunityTypePage.requestModel];
                return SlidingUpPanel(
                  minHeight: 0.0,
                  maxHeight: MediaQuery.of(context).size.height,
                  controller: _pc,
                  isDraggable: false,
                  panel: CommunityConfirmationDetailsWidget(
                    onBackPressed: _onBackPressed,
                    model: model,
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1F75E1),
                          Color(0xFF094AAC),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 18.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: ThemeColors.black0,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
                                  'Membership',
                                  style: ThemeText.sfMediumHeadline
                                      .copyWith(color: ThemeColors.black0),
                                ),
                                Spacer(),
                                Visibility(
                                  visible: !model.isEditMode,
                                  child: InkWell(
                                    onTap: () => createCommunity(type: 'free'),
                                    child: Text('Continue with free',
                                        style: ThemeText.sfMediumHeadline
                                            .copyWith(
                                                color: ThemeColors.black0)),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            SvgPicture.asset(
                              'images/illustration.svg',
                              width: double.infinity,
                              height: 260.0,
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            Text(
                              'Go Paid Community and create event for your audience',
                              textAlign: TextAlign.center,
                              style: ThemeText.rodinaTitle2
                                  .copyWith(color: ThemeColors.black0),
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Container(
                              height: 84,
                              width: double.infinity,
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: ThemeColors.yellow,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                      'images/circle_checked_white.svg'),
                                  SizedBox(
                                    width: 18.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Upgrade to paid community',
                                        style: ThemeText.sfMediumBody,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        '${getFormattedCurrency(int.parse(snapshot.data))}/year',
                                        style: ThemeText.sfSemiBoldTitle3,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
