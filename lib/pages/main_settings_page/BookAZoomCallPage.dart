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

class BookAZoomCallPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BookAZoomCallPage();
  }
}

class _BookAZoomCallPage extends State<BookAZoomCallPage> {
  final otherController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();
  bool hasClickedBook = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Color(ColorConstants.getPrimaryBlack())
              ),
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              elevation: 0,

              title: TextDandyLight(
                textAlign: TextAlign.center,
                type: TextDandyLight.LARGE_TEXT,
                isBold: true,
                text: "We want to hear from you!",
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
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
                              IntentLauncherUtil.launchURLInternalBrowser('https://y9so063tn9w.typeform.com/to/mOovSXbb');
                              setState(() {
                                hasClickedBook = true;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              alignment: Alignment.center,
                              height: 54.0,
                              decoration: BoxDecoration(
                                  color: Color(ColorConstants.getPeachDark()),
                                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24), bottomLeft: Radius.circular(24))),
                              child: TextDandyLight(
                                text: 'Take Survey',
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
              ],
            ),
    ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
