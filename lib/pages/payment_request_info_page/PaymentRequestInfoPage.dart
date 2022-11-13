import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/main_settings_page/DeleteAccountPage.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'PaymentRequestInfoPageActions.dart';


class PaymentRequestInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaymentRequestInfoPageState();
  }
}

class _PaymentRequestInfoPageState extends State<PaymentRequestInfoPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PaymentRequestInfoPageState>(
        onInit: (store) {
          store.dispatch(LoadPaymentSettingsFromProfile(store.state.paymentRequestInfoPageState));
        },
        converter: (Store<AppState> store) => PaymentRequestInfoPageState.fromStore(store),
        builder: (BuildContext context, PaymentRequestInfoPageState pageState) =>
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
                          "Payment Request Info",
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
                                              child: Image.asset('assets/images/icons/signature.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            Text(
                                              'Privacy Policy',
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
                                TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {

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
                                              child: Image.asset('assets/images/icons/signature.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            Text(
                                              'Terms and Conditions',
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
                                TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(builder: (context) => DeleteAccountPage()),
                                    );
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
                                              child: Image.asset('assets/images/icons/trash_icon_white.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            Text(
                                              'Delete Account',
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
                                )
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
