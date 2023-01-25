import 'dart:ui';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/common_widgets/DandyLightTextWidget.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/services.dart';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ManageSubscriptionPageActions.dart';

class ManageSubscriptionPage extends StatefulWidget {
  static const String FREE_TRIAL_ENDED = "free_trial_ended";
  static const String SUBSCRIPTION_EXPIRED = "subscription_expired";
  static const String DEFAULT_SUBSCRIBE = "default_subscribe";
  static const String SUBSCRIBED = "subscribed";
  final Profile profile;
  final String uiState;

  ManageSubscriptionPage(this.profile, this.uiState);

  @override
  State<StatefulWidget> createState() {
    return _ManageSubscriptionPageState(uiState, profile);
  }
}

class _ManageSubscriptionPageState extends State<ManageSubscriptionPage>
    with TickerProviderStateMixin {
  TextEditingController referralCodeTextController = TextEditingController();
  final referralCodeFocusNode = FocusNode();
  final String uiState;
  final Profile profile;

  _ManageSubscriptionPageState(this.uiState, this.profile);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageSubscriptionPageState>(
      onInit: (store) {
        store.dispatch(FetchInitialDataAction(store.state.manageSubscriptionPageState, profile));
      },
      onDidChange: (previous, current) {
        if(current.errorMsg.isNotEmpty) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
            builder: (context) {
              return Container(
                margin: EdgeInsets.only(left: 64, right: 64.0, bottom: 64.0),
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPeachDark()),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(current.errorMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(
                        ColorConstants.getPrimaryWhite()),
                  ),
                ),
              );
            },
          );
          current.resetErrorMsg();
        }
      },
      converter: (Store<AppState> store) =>
          ManageSubscriptionPageState.fromStore(store),
      builder: (BuildContext context, ManageSubscriptionPageState pageState) =>
    WillPopScope(
    onWillPop: () async => pageState.uiState == ManageSubscriptionPage.DEFAULT_SUBSCRIBE || pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? true : false,
    child: Scaffold(
            extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(ColorConstants.getBlueLight()),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 24.0),
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 64.0),
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 72.0,
                                  fontFamily: 'dandy',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryWhite())
                                      .withOpacity(1.0),
                                ),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                                child: Text(
                                  'DandyLight',
                                ),
                              ),
                            ),
                            Container(
                                width: pageState.uiState == ManageSubscriptionPage.DEFAULT_SUBSCRIBE || pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? 224 : MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 164.0),
                                child: Text(_getMessageText(pageState.uiState),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                        ColorConstants.getBlueDark()),
                                  ),
                                )
                            ),
                            pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? SizedBox() : Container(
                                margin: EdgeInsets.only(top: 258.0),
                                child: Text('Beta tester discount applied',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'simpleMedium',
                                    fontWeight: FontWeight.w500,
                                    color: Color(
                                        ColorConstants.getPeachDark()),
                                  ),
                                )
                            ),
                            pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? Container(
                                margin: EdgeInsets.only(top: 258.0),
                                child: Text('Subscription Active',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w700,
                                    color: Color(
                                        ColorConstants.getPeachDark()),
                                  ),
                                )
                            ) : SizedBox(),
                            Container(
                              margin: EdgeInsets.only(left: 114.0, top: 28),
                              height: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                  image: AssetImage(ImageUtil.LOGIN_BG_LOGO_FLOWER),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if(pageState.uiState != ManageSubscriptionPage.SUBSCRIBED) {
                                      pageState.onSubscriptionSelected(pageState.annualPackage);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: profile.isBetaTester ? 288.0 : 264),
                                    padding: EdgeInsets.only(left: 4.0, right: 20.0),
                                    height: 64.0,
                                    decoration: BoxDecoration(
                                        color: pageState.radioValue == 0 ? Color(ColorConstants.getBlueDark()) : Color(ColorConstants.getBlueLight()),
                                        borderRadius: BorderRadius.circular(16.0),
                                        border: Border.all(
                                            color: Color(ColorConstants.getBlueDark()),
                                            width: 1.0
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Radio(
                                              activeColor: Color(ColorConstants.getPrimaryWhite()),
                                              value: 0,
                                              groupValue: pageState.radioValue,
                                              onChanged: (value) {
                                                if(pageState.uiState != ManageSubscriptionPage.SUBSCRIBED) {
                                                  pageState.onSubscriptionSelected(pageState.annualPackage);
                                                }
                                              },
                                            ),
                                            Text(
                                              'Annual',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                fontFamily: 'simple',
                                                fontWeight: FontWeight.w600,
                                                color:
                                                Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                profile.isBetaTester ? '(-50%)' : '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontFamily: 'simpleMedium',
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                  Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryColor() : ColorConstants.getPeachDark()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                DandyLightTextWidget(
                                                  amount: pageState.annualPrice,
                                                  textSize: 24.0,
                                                  textColor: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                                  fontWeight: FontWeight.w600,
                                                  decimalPlaces: 2,
                                                  isCurrency: true,
                                                ),
                                                Text(
                                                  '/yr',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 24.0,
                                                    fontFamily: 'simple',
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                    Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '(',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'simple',
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                    Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                                  ),
                                                ),
                                                DandyLightTextWidget(
                                                  amount: pageState.annualPrice/12,
                                                  textSize: 16.0,
                                                  textColor: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                                  fontWeight: FontWeight.w600,
                                                  decimalPlaces: 2,
                                                  isCurrency: true,
                                                ),
                                                Text(
                                                  '/mo)',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'simple',
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                    Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(pageState.uiState != ManageSubscriptionPage.SUBSCRIBED) {
                                      pageState.onSubscriptionSelected(pageState.monthlyPackage);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 8.0, top: 16.0),
                                    padding: EdgeInsets.only(left: 4.0, right: 20.0),
                                    height: 64.0,
                                    decoration: BoxDecoration(
                                        color: pageState.radioValue == 1 ? Color(ColorConstants.getBlueDark()) : Color(ColorConstants.getBlueLight()),
                                        borderRadius: BorderRadius.circular(16.0),
                                        border: Border.all(
                                            color: Color(ColorConstants.getBlueDark()),
                                            width: 1.0
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              activeColor: Color(ColorConstants.getPrimaryWhite()),
                                              value: 1,
                                              groupValue: pageState.radioValue,
                                              onChanged: (value) {
                                                if(pageState.uiState != ManageSubscriptionPage.SUBSCRIBED) {
                                                  pageState.onSubscriptionSelected(pageState.monthlyPackage);
                                                }
                                              },
                                            ),
                                            Text(
                                              'Monthly',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                fontFamily: 'simple',
                                                fontWeight: FontWeight.w600,
                                                color:
                                                Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                profile.isBetaTester ? '(-50%)' : '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontFamily: 'simpleMedium',
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                  Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryColor() : ColorConstants.getPeachDark()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            DandyLightTextWidget(
                                              amount: pageState.monthlyPrice,
                                              textSize: 24.0,
                                              textColor: Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                              fontWeight: FontWeight.w600,
                                              decimalPlaces: 2,
                                              isCurrency: true,
                                            ),
                                            Text(
                                              '/mo',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                fontFamily: 'simple',
                                                fontWeight: FontWeight.w600,
                                                color:
                                                Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? SizedBox() : TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Enter Referral Code',
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w600,
                                        color: Color(ColorConstants.getBlueDark()),
                                      ),
                                    ),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {
                                        if(!pageState.isLoading) {
                                          switch(pageState.uiState) {
                                            case ManageSubscriptionPage.SUBSCRIBED:
                                              if(Device.get().isIos) {
                                                launchUrl(Uri.parse("https://apps.apple.com/account/subscriptions"));
                                              } else {
                                                launchUrl(Uri.parse('https://play.google.com/store/account/subscriptions?sku=pro.monthly.testsku&package=com.dandylight.mobile'));
                                              }
                                              break;
                                            case ManageSubscriptionPage.DEFAULT_SUBSCRIBE:
                                            case ManageSubscriptionPage.SUBSCRIPTION_EXPIRED:
                                            case ManageSubscriptionPage.FREE_TRIAL_ENDED:
                                              pageState.onSubscribeSelected();
                                              break;
                                          }
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
                                        height: 48.0,
                                        width: pageState.isLoading ? '' : pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? 264 : 200.0,
                                        decoration: BoxDecoration(
                                            color: Color(ColorConstants.getPrimaryWhite()),
                                            borderRadius: BorderRadius.circular(32.0)
                                        ),
                                        child: Text(
                                          pageState.isLoading ? '' : pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? 'Cancel Subscription' : 'Subscribe',
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 24.0,
                                            fontFamily: 'simple',
                                            fontWeight: FontWeight.w600,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                        ),
                                      ),
                                    ),
                                    pageState.isLoading ? Container(
                                      height: 48.0,
                                      width: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: new BorderRadius.circular(16.0),
                                      ),
                                      child: LoadingAnimationWidget.fourRotatingDots(
                                        color: Color(ColorConstants.getBlueDark()),
                                        size: 32,
                                      ),
                                    ) : SizedBox(),
                                  ],
                                ),
                                Text(
                                  'You can cancel your subscription at any time.',
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.getBlueDark()),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 32.0, bottom: 16.0),
                                  child: Text(
                                    'Payment will be charged to your ' + (Device.get().isIos ? 'iTunes' : 'GooglePlay') + ' account, and your account will be charged for renewal 24-hours prior to the end of the current period. Auto-renewal may be turned off at any time by going to your settings in the App Store after purchase.',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.getBlueDark()),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {

                                      },
                                      child: Container(
                                        child: Text(
                                          'Terms of service',
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'simple',
                                            fontWeight: FontWeight.w600,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {

                                      },
                                      child: Container(
                                        child: Text(
                                          'Privacy policy',
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'simple',
                                            fontWeight: FontWeight.w600,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (pageState.uiState == ManageSubscriptionPage.DEFAULT_SUBSCRIBE || pageState.uiState == ManageSubscriptionPage.SUBSCRIBED) ?
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                title: Text(''),// You can add title here
                leading: new IconButton(
                  icon: new Icon((Device.get().isIos ? CupertinoIcons.back : Icons.arrow_back), color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.transparent, //You can make this transparent
                elevation: 0.0, //No shadow
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    ),
    );
  }

  String _getMessageText(String uiState) {
    String message = '';
    switch(uiState) {
      case ManageSubscriptionPage.DEFAULT_SUBSCRIBE:
      case ManageSubscriptionPage.SUBSCRIBED:
        message = 'Capture the moment We\'ll do the rest';
        break;
      case ManageSubscriptionPage.SUBSCRIPTION_EXPIRED:
        message = 'Your subscription has expired. Please resubscribe to regain access to your account.';
        break;
      case ManageSubscriptionPage.FREE_TRIAL_ENDED:
        message = 'Your free trial has ended. Please select a subscription option to continue using DandyLight.';
        break;
    }
    return message;
  }
}
