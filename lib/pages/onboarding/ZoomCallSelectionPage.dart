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
                        padding: const EdgeInsets.only(top: 16),
                        margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0, bottom: 0.0),
                        alignment: Alignment.center,

                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_LARGE_TEXT,
                                text: '3 MONTHS FREE',
                                textAlign: TextAlign.center,
                                isBold: true,
                              ),
                            ),
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
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'We value your feedback! Participate in a brief survey to share your insights, helping us enhance your experience and tailor our services to your preferences.',
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    IntentLauncherUtil.launchURLInternalBrowser('https://y9so063tn9w.typeform.com/to/mOovSXbb');
                    setState(() {
                      hasClickedBook = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 108, left: 64, right: 64),
                    alignment: Alignment.center,
                    height: 72.0,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getPeachDark()),
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: TextDandyLight(
                      text: 'Take Survey',
                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.setPagerIndex!(4);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: const EdgeInsets.only(left: 84.0, right: 84.0, top: 0.0, bottom: 32.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                        borderRadius: BorderRadius.circular(36.0),
                    ),
                    child: TextDandyLight(
                      text: hasClickedBook ? 'Continue' : 'No thank you',
                      type: TextDandyLight.LARGE_TEXT,
                      color: Color(ColorConstants.getPrimaryBlack()),
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
