import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/TextDandyLight.dart';

class SubscribeNowPage extends StatefulWidget {
  final Profile profile;

  SubscribeNowPage({this.profile});

  @override
  State<StatefulWidget> createState() {
    return _SubscribeNowPageState(profile);
  }
}

class _SubscribeNowPageState extends State<SubscribeNowPage> with TickerProviderStateMixin {
  Profile profile;

  _SubscribeNowPageState(this.profile);

  @override
  Widget build(BuildContext context) => Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ListView(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 54.0),
                            child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: 'Your 3 job limit has \nbeen reached...',
                              textAlign: TextAlign.center,
                              isBold: true,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 32.0, left: 32, right: 32),
                            child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: 'Upgrade today for unlimited new jobs and get access to:',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32, top: 16),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 16, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Unlimited jobs',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Unlimited invoices',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Unlimited mileage tracking',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Unlimited expense tracking',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Business analytics',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Synced calendar',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Unlimited locations',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Unlimited poses',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Unlimited responses',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32, bottom: 8),
                            child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 24, left: 32, right: 32),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Coming Soon Features:',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                color: Color(ColorConstants.getPrimaryGreyMedium()),
                              ),
                            ),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check, color: Color(ColorConstants.getPrimaryGreyMedium()),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Unlimited contracts',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check, color: Color(ColorConstants.getPrimaryGreyMedium()),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Unlimited questionnaires',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check, color: Color(ColorConstants.getPrimaryGreyMedium()),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Automated booking',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 4, left: 32, right: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check, color: Color(ColorConstants.getPrimaryGreyMedium()),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Unlimited proposals',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        NavigationUtil.onManageSubscriptionSelected(context, profile);
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 54, left: 32, right: 32),
                          height: 54,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27),
                              color: Color(ColorConstants.getPeachDark())
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            textAlign: TextAlign.center,
                            text: "FIND A PLAN FOR YOU",
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(top: 48),
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Close',
                        color: Color(ColorConstants.getPeachDark()),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
      );
}
