import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import 'DashboardPageState.dart';


class RequestAppReviewBottomSheet extends StatefulWidget {
  const RequestAppReviewBottomSheet({Key key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _RequestAppReviewBottomSheetState();
  }
}

class _RequestAppReviewBottomSheetState extends State<RequestAppReviewBottomSheet> with TickerProviderStateMixin {
  InAppReview inAppReview;
  int state = 0;


  @override
  void initState() {
    super.initState();
    inAppReview = InAppReview.instance;
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color(ColorConstants.getPrimaryBlack());
    }
    return Color(ColorConstants.getPeachDark());
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Container(
           height: 314,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
             child: buildBody(pageState),
         ),
    );

  Widget buildBody(DashboardPageState pageState) {
    if(state == 0) {//Question
      return buildQuestion(pageState);
    }
    if(state == 1) {//NO
      return buildWhatCanWeDoBetter(pageState);
    }
    if(state == 2) {//YES
      return buildActionsBody(pageState);
    }
    return const SizedBox();
  }

  Widget buildWhatCanWeDoBetter(DashboardPageState pageState) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(bottom: 32, left: 12, right: 12),
          child: TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: 'What can we do better?',
          ),
        ),
        GestureDetector(
          onTap: () {
            _sendSuggestion(pageState);
            pageState.updateCanShowRequestReview(false, DateTime.now());
            EventSender().sendEvent(eventName: EventNames.BT_TAKE_PMF_SURVEY);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 96),
            alignment: Alignment.center,
            height: 54,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: Color(ColorConstants.getPeachDark())
            ),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'Send Suggestion',
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 198),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: !pageState.profile.canShowAppReview,
                onChanged: (checked) {
                  pageState.updateCanShowRequestReview(!checked, DateTime.now());
                },
                checkColor: Color(ColorConstants.getPrimaryWhite()),
                fillColor: MaterialStateProperty.resolveWith(getColor),
              ),
              TextDandyLight(
                type: TextDandyLight.SMALL_TEXT,
                text: 'do not show again',
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              const SizedBox(width: 14)
            ],
          ),
        ),
      ],
    );
  }

  Widget buildActionsBody(DashboardPageState pageState) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(bottom: 32, left: 12, right: 12),
          child: TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: 'Would you like to help DandyLight by giving us a rating or sharing with a friend?',
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
              pageState.updateCanShowRequestReview(false, DateTime.now());
              EventSender().sendEvent(eventName: EventNames.BT_REVIEW_APP);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 164),
            alignment: Alignment.center,
            height: 54,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: Color(ColorConstants.getPeachDark())
            ),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'Rate',
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Share.share('Checkout DandyLight:\n\nhttps://linktr.ee/dandylight');
            pageState.updateCanShowRequestReview(false, DateTime.now());
            EventSender().sendEvent(eventName: EventNames.BT_SHARE_WITH_FRIEND);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 96),
            alignment: Alignment.center,
            height: 54,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: Color(ColorConstants.getPeachDark())
            ),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'Share',
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 198),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: !pageState.profile.canShowAppReview,
                onChanged: (checked) {
                  pageState.updateCanShowRequestReview(!checked, DateTime.now());
                },
                checkColor: Color(ColorConstants.getPrimaryWhite()),
                fillColor: MaterialStateProperty.resolveWith(getColor),
              ),
              TextDandyLight(
                type: TextDandyLight.SMALL_TEXT,
                text: 'do not show again',
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              const SizedBox(width: 14)
            ],
          ),
        ),
      ],
    );
  }

  Widget buildQuestion(DashboardPageState pageState) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(bottom: 32, left: 12, right: 12),
          child: TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: 'Are you enjoying DandyLight?',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 72),
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    state = 1;
                  });
                  EventSender().sendEvent(eventName: EventNames.BT_ENJOYING_DANDY_LIGHT_NO);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      color: Color(ColorConstants.getBlueDark())
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'NO',
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                    pageState.updateCanShowRequestReview(false, DateTime.now());
                    EventSender().sendEvent(eventName: EventNames.BT_ENJOYING_DANDY_LIGHT_YES);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      color: Color(ColorConstants.getPeachDark())
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'YES',
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 198),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: !pageState.profile.canShowAppReview,
                onChanged: (checked) {
                  pageState.updateCanShowRequestReview(!checked, DateTime.now());
                },
                checkColor: Color(ColorConstants.getPrimaryWhite()),
                fillColor: MaterialStateProperty.resolveWith(getColor),
              ),
              TextDandyLight(
                type: TextDandyLight.SMALL_TEXT,
                text: 'do not show again',
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              const SizedBox(width: 14)
            ],
          ),
        ),
      ],
    );
  }

  void _sendSuggestion(DashboardPageState pageState) async => await IntentLauncherUtil.sendEmail('support@dandylight.com', "Suggestion", 'User Info: \nid = ${pageState.profile.uid}\naccount email = ${pageState.profile.email}\nfirst name = ${pageState.profile.firstName}\n\nSuggestion: ');

}