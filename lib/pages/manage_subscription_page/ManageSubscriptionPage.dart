import 'dart:io';
import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
import 'package:dandylight/pages/manage_subscription_page/UnsubscribeBottomSheet.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:dandylight/utils/styles/Styles.dart';

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

import '../../data_layer/api_clients/DandylightFunctionsClient.dart';
import '../../data_layer/repositories/PendingEmailsRepository.dart';
import '../../utils/AdminCheckUtil.dart';
import '../../utils/DeviceType.dart';
import '../../utils/analytics/EventNames.dart';
import '../../widgets/TextDandyLight.dart';
import 'EnterDiscountCodeBottomSheet.dart';
import 'ManageSubscriptionPageActions.dart';
import 'package:http/http.dart' as http;


class ManageSubscriptionPage extends StatefulWidget {
  static const String SUBSCRIPTION_EXPIRED = "subscription_expired";
  static const String FREE_TRIAL = "free_trial";
  static const String SUBSCRIBED = "subscribed";
  static const String PACKAGE_MONTHLY = 'package_monthly';
  static const String PACKAGE_ANNUAL = 'package_annual';
  final Profile profile;

  const ManageSubscriptionPage(this.profile, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManageSubscriptionPageState(profile);
  }
}

class _ManageSubscriptionPageState extends State<ManageSubscriptionPage>
    with TickerProviderStateMixin {
  TextEditingController referralCodeTextController = TextEditingController();
  final codeTextController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  final referralCodeFocusNode = FocusNode();
  Profile? profile;
  String errorMsg = '';

  _ManageSubscriptionPageState(this.profile);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageSubscriptionPageState>(
      onInit: (store) {
        store.dispatch(FetchInitialDataAction(store.state.manageSubscriptionPageState, profile));
      },
      onDidChange: (previous, current) {
        if(current.profile != null) {
          setState(() {
            profile = current.profile!;
          });
        }
        if(current.errorMsg!.isNotEmpty) {
          if(current.errorMsg != errorMsg) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
              builder: (context) {
                return Container(
                  margin: const EdgeInsets.only(left: 32, right: 32.0, bottom: 64.0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.getPeachDark()),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(current.errorMsg!,
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
            errorMsg = current.errorMsg!;
            current.resetErrorMsg!();
          }
        }
        if(current.shouldPopBack!) {
          Navigator.of(context).pop();
        }
      },
      converter: (Store<AppState> store) =>
          ManageSubscriptionPageState.fromStore(store),
      builder: (BuildContext context, ManageSubscriptionPageState pageState) =>
    WillPopScope(
      onWillPop: () async => (pageState.uiState == ManageSubscriptionPage.FREE_TRIAL || pageState.uiState == ManageSubscriptionPage.SUBSCRIBED || AdminCheckUtil.isAdmin(profile) || profile!.isFreeForLife!) ? true : false,
    child: Scaffold(
            extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(ColorConstants.getBlueLight()),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
        SliverPadding(
        padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
      sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 64.0),
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 72.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryWhite()).withOpacity(1.0),
                                ),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                                child: const Text(
                                  'DandyLight',
                                ),
                              ),
                            ),
                            profile != null && profile!.isFreeForLife! ? Container(
                                margin: const EdgeInsets.only(top: 178.0),
                                child: TextDandyLight(
                                    text: 'Your free lifetime subscription is applied! There is no need to manage your subscription. We hope you enjoy Dandylight!',
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getBlueDark())
                                )
                            ) : const SizedBox(),
                            !(profile != null && profile!.isFreeForLife!) && (pageState.uiState != ManageSubscriptionPage.FREE_TRIAL) ? Container(
                                margin: const EdgeInsets.only(top: 178.0),
                                child: TextDandyLight(
                                    text: _getMessageText(pageState!.uiState!),
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getBlueDark())
                                )
                            ) : const SizedBox(),
                            !(profile != null && profile!.isFreeForLife!) && (pageState.uiState == ManageSubscriptionPage.FREE_TRIAL) ? Container(
                                margin: const EdgeInsets.only(top: 164.0),
                                child: TextDandyLight(
                                    text: pageState.remainingTimeMessage,
                                    type: TextDandyLight.SMALL_TEXT,
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getBlueDark())
                                )
                            ) : const SizedBox(),
                            !(profile != null && profile!.isFreeForLife!) && pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? const SizedBox() : profile!.isBetaTester! || pageState.discountType!.isNotEmpty ? Container(
                                margin: const EdgeInsets.only(top: 258.0),
                                child: TextDandyLight(
                                  text: pageState.discountType == DiscountCodes.FIRST_3_MONTHS_FREE ? 'Discount applied - First 3 months free' : 'Discount applied',
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  textAlign: TextAlign.center,
                                  isBold: true,
                                  color: Color(ColorConstants.getPrimaryBlack())
                                )
                            ) : const SizedBox(),
                            !(profile != null && profile!.isFreeForLife!) && (pageState.uiState == ManageSubscriptionPage.SUBSCRIBED) ? Container(
                                margin: const EdgeInsets.only(top: 258.0),
                                child: TextDandyLight(
                                    text: 'Subscription Active',
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getPeachDark())
                                )
                            ) : const SizedBox(),
                            Container(
                              margin: const EdgeInsets.only(left: 114.0, top: 28),
                              height: 150.0,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                  image: AssetImage(ImageUtil.LOGIN_BG_LOGO_FLOWER),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            !(profile != null && profile!.isFreeForLife!) ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if(pageState.uiState != ManageSubscriptionPage.SUBSCRIBED) {
                                      pageState.onSubscriptionSelected!(ManageSubscriptionPage.PACKAGE_ANNUAL);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 288.0),
                                    padding: const EdgeInsets.only(left: 4.0, right: 20.0),
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
                                                  pageState.onSubscriptionSelected!(ManageSubscriptionPage.PACKAGE_ANNUAL);
                                                }
                                              },
                                            ),
                                            TextDandyLight(
                                                text: 'Annual',
                                                type: TextDandyLight.LARGE_TEXT,
                                                textAlign: TextAlign.center,
                                                color: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8.0),
                                              child: TextDandyLight(
                                                text: profile!.isBetaTester! || pageState.discountType == DiscountCodes.FIFTY_PERCENT_TYPE ? '(-50%)' : pageState.discountType == DiscountCodes.LIFETIME_FREE ? '(-100%)' : '',
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                color: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryColor() : ColorConstants.getBlueDark()),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                TextDandyLight(
                                                  type: TextDandyLight.LARGE_TEXT,
                                                  amount: pageState.annualPrice,
                                                  color: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                                  isCurrency: true,
                                                ),
                                                TextDandyLight(
                                                  text: '/yr',
                                                  textAlign: TextAlign.center,
                                                  type: TextDandyLight.LARGE_TEXT,
                                                  color: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                TextDandyLight(
                                                  text: '(',
                                                  textAlign: TextAlign.center,
                                                  type: TextDandyLight.MEDIUM_TEXT,
                                                  color: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryColor() : ColorConstants.getBlueDark()),
                                                ),
                                                TextDandyLight(
                                                  type: TextDandyLight.MEDIUM_TEXT,
                                                  amount: pageState.monthlyPrice!,
                                                  color: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryColor() : ColorConstants.getBlueDark()),
                                                  isCurrency: true,
                                                ),
                                                TextDandyLight(
                                                  text: '/mo)',
                                                  textAlign: TextAlign.center,
                                                  type: TextDandyLight.MEDIUM_TEXT,
                                                  color: Color(pageState.radioValue == 0 ? ColorConstants.getPrimaryColor() : ColorConstants.getBlueDark()),
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
                                      pageState.onSubscriptionSelected!(ManageSubscriptionPage.PACKAGE_MONTHLY);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                                    padding: const EdgeInsets.only(left: 4.0, right: 20.0),
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
                                                  pageState.onSubscriptionSelected!(ManageSubscriptionPage.PACKAGE_MONTHLY);
                                                }
                                              },
                                            ),
                                            TextDandyLight(
                                              text: 'Monthly',
                                              textAlign: TextAlign.center,
                                              type: TextDandyLight.LARGE_TEXT,
                                              color: Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8.0),
                                              child: TextDandyLight(
                                                text: profile!.isBetaTester! || pageState.discountType == DiscountCodes.FIFTY_PERCENT_TYPE  ? '(-50%)' : pageState.discountType == DiscountCodes.LIFETIME_FREE ? '(-100%)' : '',
                                                textAlign: TextAlign.center,
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                color: Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryColor() : ColorConstants.getBlueDark()),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            TextDandyLight(
                                              type: TextDandyLight.LARGE_TEXT,
                                              amount: pageState.monthlyPrice,
                                              isCurrency: true,
                                              color: Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                            ),
                                            TextDandyLight(
                                              type: TextDandyLight.LARGE_TEXT,
                                              text: '/mo',
                                              textAlign: TextAlign.center,
                                              color: Color(pageState.radioValue == 1 ? ColorConstants.getPrimaryWhite() : ColorConstants.getBlueDark()),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? const SizedBox() : TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {
                                    _showEnterDiscountCodeBottomSheet(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Enter Discount Code',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getBlueDark())
                                    ),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {
                                        if(!pageState.isLoading! && !profile!.isFreeForLife!) {
                                          switch(pageState.uiState) {
                                            case ManageSubscriptionPage.SUBSCRIBED:
                                              _showUnsubscribeBottomSheet(context);
                                              EventSender().sendEvent(eventName: EventNames.BT_CANCEL_SUBSCRIPTION);
                                              PendingEmailsRepository(functions: DandylightFunctionsApi(httpClient: http.Client())).sendTrialLimitReachedEmail();
                                              break;
                                            case ManageSubscriptionPage.FREE_TRIAL:
                                            case ManageSubscriptionPage.SUBSCRIPTION_EXPIRED:
                                              pageState.onSubscribeSelected!();
                                              break;
                                          }
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                                        height: 48.0,
                                        width: pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? 264 : 200.0,
                                        decoration: BoxDecoration(
                                            color: Color(profile!.isFreeForLife! ? ColorConstants.getPrimaryBackgroundGrey() : ColorConstants.getPrimaryWhite()),
                                            borderRadius: BorderRadius.circular(32.0)
                                        ),
                                        child: TextDandyLight(
                                          type: TextDandyLight.LARGE_TEXT,
                                          text: pageState.isLoading! ? '' : pageState.uiState == ManageSubscriptionPage.SUBSCRIBED ? 'Cancel Subscription' : 'Subscribe',
                                          textAlign: TextAlign.center,
                                          color: Color(profile!.isFreeForLife! ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getBlueDark()),
                                        ),
                                      ),
                                    ),
                                    pageState.isLoading! ? Container(
                                      height: 48.0,
                                      width: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: LoadingAnimationWidget.fourRotatingDots(
                                        color: Color(ColorConstants.getBlueDark()),
                                        size: 32,
                                      ),
                                    ) : const SizedBox(),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Both plans include',
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getBlueDark()),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 16, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: 'Unlimited jobs & invoices',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: 'Unlimited contracts',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: 'Client Portal',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Unlimited Mileage tracking',
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: 'Unlimited expense tracking',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Income tracking',
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Business analytics',
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Synced calendar',
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: 'Unlimited Custom reminders',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4, left: 32, right: 32, bottom: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, color: Color(ColorConstants.getBlueDark()),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Unlimited locations, poses\n& responses',
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            color: Color(ColorConstants.getBlueDark()),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextDandyLight(
                                  type: TextDandyLight.EXTRA_SMALL_TEXT,
                                  text: 'You can cancel your subscription at any time.',
                                  textAlign: TextAlign.center,
                                  color: Color(ColorConstants.getBlueDark()),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.EXTRA_SMALL_TEXT,
                                    text: 'Payment will be charged to your ${Device.get().isIos ? 'iTunes' : 'GooglePlay'} account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user\'s Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.',
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getBlueDark()),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Platform.isIOS ? TextButton(
                                        style: Styles.getButtonStyle(),
                                        onPressed: () {
                                          _launchTermsOfService();
                                        },
                                        child: TextDandyLight(
                                          type: TextDandyLight.SMALL_TEXT,
                                          text: 'Terms of Use',
                                          textAlign: TextAlign.center,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      ) : TextButton(
                                        style: Styles.getButtonStyle(),
                                        onPressed: () {
                                          _launchTermsOfServiceURL();
                                        },
                                        child: TextDandyLight(
                                          type: TextDandyLight.SMALL_TEXT,
                                          text: 'Terms of service',
                                          textAlign: TextAlign.center,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      ),
                                      TextButton(
                                        style: Styles.getButtonStyle(),
                                        onPressed: () {
                                          _launchPrivacyPolicyURL();
                                        },
                                        child: TextDandyLight(
                                          type: TextDandyLight.SMALL_TEXT,
                                          text: 'Privacy Policy',
                                          textAlign: TextAlign.center,
                                          color: Color(ColorConstants.getBlueDark()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ) : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
              ],
            ),
            (pageState.uiState == ManageSubscriptionPage.FREE_TRIAL || pageState.uiState == ManageSubscriptionPage.SUBSCRIBED || AdminCheckUtil.isAdmin(profile) || (profile != null && profile!.isFreeForLife!)) ?
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                surfaceTintColor: Colors.transparent,
                title: const Text(''),// You can add title here
                leading: IconButton(
                  icon: Icon((Device.get().isIos ? CupertinoIcons.back : Icons.arrow_back), color: Color(ColorConstants.getPrimaryWhite())),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.transparent, //You can make this transparent
                elevation: 0.0, //No shadow
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    ),
    );
  }

  String _getMessageText(String uiState) {
    String message = '';
    switch(uiState) {
      case ManageSubscriptionPage.FREE_TRIAL:
      case ManageSubscriptionPage.SUBSCRIBED:
        message = 'Capture the moment\n We\'ll do the rest';
        break;
      case ManageSubscriptionPage.SUBSCRIPTION_EXPIRED:
        message = 'Your subscription has expired. Please resubscribe to regain unlimited access to your account.';
        break;
    }
    return message;
  }

  void onCodeAction(){
    _codeFocusNode.unfocus();
  }

  void _showEnterDiscountCodeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return EnterDiscountCodeBottomSheet();
      },
    );
  }

  void _showUnsubscribeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return UnsubscribeBottomSheet();
      },
    );
  }

  void _launchPrivacyPolicyURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) : throw 'Could not launch';
  void _launchTermsOfServiceURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) : throw 'Could not launch';
  void _launchTermsOfService() async => await canLaunchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) ? await launchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) : throw 'Could not launch';
}
