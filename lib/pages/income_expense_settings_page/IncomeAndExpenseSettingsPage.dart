import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageActions.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:io' show Platform;

import '../../utils/analytics/EventSender.dart';


class IncomeAndExpenseSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IncomeAndExpenseSettingsPageState();
  }
}

class _IncomeAndExpenseSettingsPageState extends State<IncomeAndExpenseSettingsPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, IncomeAndExpenseSettingsPageState>(
        onInit: (store) {
          store.dispatch(LoadPaymentSettingsFromProfile(store.state.incomeAndExpenseSettingsPageState));
        },
        converter: (Store<AppState> store) => IncomeAndExpenseSettingsPageState.fromStore(store),
        builder: (BuildContext context, IncomeAndExpenseSettingsPageState pageState) =>
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      iconTheme: IconThemeData(
                        color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                      ),
                      brightness: Brightness.light,
                      backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0.0,
                      title: Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 26.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                    ),
                    SliverList(
                      delegate: new SliverChildListDelegate(
                        <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {
                                    NavigationUtil.onPaymentRequestInfoSelected(context);
                                    EventSender().sendEvent(eventName: EventNames.NAV_TO_PAYMENT_LINK_INFO);
                                  },
                                  child: SizedBox(
                                    height: 48.0,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(right: 16.0),
                                              height: 28.0,
                                              width: 28.0,
                                              child: Image.asset('assets/images/collection_icons/pricing_profile_icons/wallet_icon_gold.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            Text(
                                              'Payment request info',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontFamily: 'simple',
                                                fontWeight: FontWeight.w600,
                                                color: Color(ColorConstants
                                                    .getPrimaryBlack()),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      DandyToastUtil.showToast('Generate report feature coming soon!', Color(ColorConstants.getPrimaryColor()));
                                      EventSender().sendEvent(eventName: EventNames.BT_GENERATE_INCOME_EXPENSE_REPORT);
                                    },
                                    child: SizedBox(
                                      height: 48.0,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Icon(Platform.isIOS ? CupertinoIcons.share : Icons.share, color: Color(ColorConstants.getPrimaryBlack()),),
                                              ),
                                              Text(
                                                'Generate income\nand expense report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontFamily: 'simple',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(ColorConstants
                                                      .getPrimaryBlack()),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Icon(
                                              Icons.chevron_right,
                                              color: Color(ColorConstants
                                                  .getPrimaryBackgroundGrey()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
}
