import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageActions.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class IncomeAndExpenseSettingsPage extends StatefulWidget {
  const IncomeAndExpenseSettingsPage({Key? key}) : super(key: key);

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
          store.dispatch(LoadIncomeExpenseReportsAction(store.state.incomeAndExpenseSettingsPageState));
          store.dispatch(LoadMileageReportsAction(store.state.incomeAndExpenseSettingsPageState));
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
                      backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0.0,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Settings",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
                            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(12.0),
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
                                              margin: const EdgeInsets.only(right: 16.0),
                                              height: 32.0,
                                              width: 32.0,
                                              child: Image.asset('assets/images/icons/credit_card.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            TextDandyLight(
                                              type: TextDandyLight.MEDIUM_TEXT,
                                              text: 'Payment request info',
                                              textAlign: TextAlign.center,
                                              color: Color(ColorConstants.getPrimaryBlack()),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Color(ColorConstants
                                              .getPrimaryBackgroundGrey()),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  child: TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      NavigationUtil.onIncomeExpenseReportSelected(context);
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
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 32.0,
                                                width: 32.0,
                                                child:  Image.asset("assets/images/icons/download.png", color: Color(ColorConstants.getPrimaryBlack()),),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Generate income\nand expense report',
                                                textAlign: TextAlign.start,
                                                color: Color(ColorConstants.getPrimaryBlack()),
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
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  child: TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      NavigationUtil.onMileageReportSelected(context);
                                      EventSender().sendEvent(eventName: EventNames.BT_GENERATE_MILEAGE_REPORT);
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
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 32.0,
                                                width: 32.0,
                                                child:  Image.asset("assets/images/icons/download.png", color: Color(ColorConstants.getPrimaryBlack()),),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Generate mileage report',
                                                textAlign: TextAlign.start,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
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
