import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/transaction/discount_status.dart';
import 'package:localin/model/transaction/transaction_discount_response_model.dart';
import 'package:localin/provider/transaction_discount_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class CouponCodeRowWidget extends StatelessWidget {
  final ValueChanged<PriceData> onChanged;
  final ValueChanged<DiscountStatus> onAppliedParams;
  final int priceToBeCalculated;

  CouponCodeRowWidget(
      {@required this.onChanged,
      @required this.onAppliedParams,
      this.priceToBeCalculated});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionDiscountProvider>(
      create: (_) => TransactionDiscountProvider(priceToBeCalculated),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
            color: ThemeColors.black0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    color: ThemeColors.black20,
                    child: Text('COUPON CODE',
                        style: ThemeText.sfSemiBoldFootnote
                            .copyWith(color: ThemeColors.black80))),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 19.0, horizontal: 16.0),
                  child: TextFormField(
                    controller: Provider.of<TransactionDiscountProvider>(
                            context,
                            listen: false)
                        .couponController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12.0),
                      hintText: 'Coupon Code',
                      hintStyle: ThemeText.rodinaTitle3
                          .copyWith(color: ThemeColors.black60),
                      suffixIcon: InkResponse(
                        onTap: () async {
                          CustomDialog.showLoadingDialog(context,
                              message: 'Loading');
                          FocusScope.of(context).unfocus();
                          final provider =
                              Provider.of<TransactionDiscountProvider>(context);
                          final response =
                              await provider.getTransactionDiscount();
                          if (response != null && !response.isError) {
                            onChanged(response.priceData);
                            onAppliedParams(DiscountStatus(
                              isUsingLocalPoint:
                                  provider.isUseLocalPoint ? 1 : 0,
                              couponValue: provider.couponController.text,
                            ));
                            CustomToast.showCustomToastWhite(
                                context,
                                !provider.isUseLocalPoint
                                    ? 'Removing coupon discount'
                                    : 'Successfully add discount with coupon.');
                          } else {
                            CustomToast.showCustomToastWhite(
                                context, response?.message);
                          }
                          CustomDialog.closeDialog(context);
                        },
                        child: SvgPicture.asset(
                          'images/icon_enter.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Consumer<TransactionDiscountProvider>(
                    builder: (_, provider, __) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('Use Local Point',
                                  style: ThemeText.sfMediumHeadline),
                            ),
                            InkResponse(
                              onTap: () async {
                                CustomDialog.showLoadingDialog(context,
                                    message: 'Loading');
                                provider.switchLocalPointUsage();
                                final response =
                                    await provider.getTransactionDiscount();
                                if (response != null && !response.isError) {
                                  onChanged(response.priceData);
                                  onAppliedParams(DiscountStatus(
                                    isUsingLocalPoint:
                                        provider.isUseLocalPoint ? 1 : 0,
                                    couponValue: provider.couponController.text,
                                  ));
                                  CustomToast.showCustomToastWhite(
                                      context,
                                      !provider.isUseLocalPoint
                                          ? 'Removing local point discount'
                                          : 'Successfully add discount with local point.');
                                } else {
                                  CustomToast.showCustomToastWhite(
                                      context, response.message);
                                }
                                CustomDialog.closeDialog(context);
                              },
                              child: provider.isUseLocalPoint
                                  ? Container(
                                      width: 14.0,
                                      height: 14.0,
                                      margin: const EdgeInsets.only(
                                          bottom: 10.0, right: 10.0),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: ThemeColors.black60,
                                      ),
                                    )
                                  : Container(
                                      width: 14.0,
                                      height: 14.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ThemeColors.black60),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                            )
                          ],
                        ),
                        Divider(
                          color: ThemeColors.black80,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
