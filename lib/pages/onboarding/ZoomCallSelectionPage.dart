import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/Shadows.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class ZoomCallSelectionPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ZoomCallSelectionPage();
  }
}

class _ZoomCallSelectionPage extends State<ZoomCallSelectionPage> {
  final otherController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();
  bool hasClickedBook = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnBoardingPageState>(
      converter: (store) => OnBoardingPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(left: 0, top: 54, right: 0, bottom: 0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 32, right: 32),
                      child: TextDandyLight(
                        textAlign: TextAlign.center,
                        type: TextDandyLight.LARGE_TEXT,
                        isBold: true,
                        text: "We want to talk to you!",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0, bottom: 0.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(24.0)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: OnBoardingPageState.APP_WALKTHROUGH,
                              textAlign: TextAlign.start,
                              isBold: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Get acquainted with our app! Let\'s walk through its features together, ensuring you get the most out of your experience from the start.',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              IntentLauncherUtil.launchURLInternalBrowser('https://calendly.com/dandylight/app-walkthrough');
                              setState(() {
                                hasClickedBook = true;
                              });
                              EventSender().sendEvent(
                                  eventName: EventNames.ON_BOARDING_BOOK_ZOOM_CALL,
                                  properties: {EventNames.ON_BOARDING_BOOK_ZOOM_CALL_PARAMS : OnBoardingPageState.APP_WALKTHROUGH}
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              alignment: Alignment.center,
                              height: 54.0,
                              decoration: BoxDecoration(
                                  color: Color(ColorConstants.getPeachDark()),
                                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24), bottomLeft: Radius.circular(24))),
                              child: TextDandyLight(
                                text: 'Book Zoom Call',
                                type: TextDandyLight.LARGE_TEXT,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 16),
                        margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0, bottom: 0.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                            borderRadius: BorderRadius.circular(24.0)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: OnBoardingPageState.FIRST_TIME_SETUP,
                                textAlign: TextAlign.start,
                                isBold: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Embark on your journey with us! Schedule a call to ensure your initial setup is smooth sailing, tailored to your specific needs and preferences.',
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                IntentLauncherUtil.launchURLInternalBrowser('https://calendly.com/dandylight/first-time-setup');
                                setState(() {
                                  hasClickedBook = true;
                                });
                                EventSender().sendEvent(
                                    eventName: EventNames.ON_BOARDING_BOOK_ZOOM_CALL,
                                    properties: {EventNames.ON_BOARDING_BOOK_ZOOM_CALL_PARAMS : OnBoardingPageState.FIRST_TIME_SETUP}
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 16.0),
                                alignment: Alignment.center,
                                height: 54.0,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPeachDark()),
                                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24), bottomLeft: Radius.circular(24))),
                                child: TextDandyLight(
                                  text: 'Book Zoom Call',
                                  type: TextDandyLight.LARGE_TEXT,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 16),
                        margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0, bottom: 164.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                            borderRadius: BorderRadius.circular(24.0)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: OnBoardingPageState.NEW_USER_SURVEY,
                                textAlign: TextAlign.center,
                                isBold: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'We value your feedback! Participate in a brief survey to share your insights, helping us enhance your experience and tailor our services to your preferences.',
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                IntentLauncherUtil.launchURLInternalBrowser('https://calendly.com/dandylight/15-min-survey');
                                setState(() {
                                  hasClickedBook = true;
                                });
                                EventSender().sendEvent(
                                    eventName: EventNames.ON_BOARDING_BOOK_ZOOM_CALL,
                                    properties: {EventNames.ON_BOARDING_BOOK_ZOOM_CALL_PARAMS : OnBoardingPageState.NEW_USER_SURVEY}
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 16.0),
                                alignment: Alignment.center,
                                height: 54.0,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPeachDark()),
                                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24), bottomLeft: Radius.circular(24))),
                                child: TextDandyLight(
                                  text: 'Book Zoom Call',
                                  type: TextDandyLight.LARGE_TEXT,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    pageState.setPagerIndex!(4);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: const EdgeInsets.only(left: 64.0, right: 64.0, top: 0.0, bottom: 32.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryBlack()),
                        borderRadius: BorderRadius.circular(36.0),
                        boxShadow: ElevationToShadow[4],
                    ),
                    child: TextDandyLight(
                      text: hasClickedBook ? 'Continue' : 'No thank you',
                      type: TextDandyLight.LARGE_TEXT,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
