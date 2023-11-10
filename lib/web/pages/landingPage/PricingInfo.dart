import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/FontTheme.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/DeviceType.dart';
import '../../../widgets/TextDandyLight.dart';

class PricingInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PricingInfoPageState();
  }
}

class _PricingInfoPageState extends State<PricingInfo> {
  List<bool> selections = List.generate(2, (index) => index == 1 ? false : true);
  bool monthlySelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 264),
      color: Color(ColorConstants.getBlueDark()),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 32, bottom: 32, right: 32, left: 32),
            child: Text(
              'Subscription Pricing',
              style: TextStyle(
                  fontSize: 36,
                  fontFamily: FontTheme.MONTSERRAT,
                  color: Color(ColorConstants.getPrimaryWhite()),
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
          ),
          DeviceType.getDeviceTypeByContext(context) == Type.Website ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              freeTrialInfo(),
              SizedBox(width: 64),
              subscriptionInfo(),
            ],
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              subscriptionInfo(),
              SizedBox(width: 64),
              freeTrialInfo(),
            ],
          )
        ],
      ),
    );
  }

  Widget freeTrialInfo() {
    return Container(
      alignment: Alignment.topCenter,
      height: 650,
      width: 396,
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(ColorConstants.getPrimaryWhite())
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 32),
            alignment: Alignment.centerLeft,
            child: Text(
              'Free Trial',
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: FontTheme.OPEN_SANS,
                  color: Color(ColorConstants.getPrimaryBlack()),
                  fontWeight: FontWeight.w900
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 22),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Try at your own pace with ", style: TextStyle(
                        fontSize: 18,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.w200,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "NO TIME LIMIT", style: TextStyle(
                        fontSize: 18,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.w900,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " and ", style: TextStyle(
                        fontSize: 18,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.w200,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "NO CREDIT CARD", style: TextStyle(
                        fontSize: 18,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.w900,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " required.", style: TextStyle(
                        fontSize: 18,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.w200,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(top: 38),
            alignment: Alignment.centerLeft,
            child: Text(
              'What\'s included:',
              style: TextStyle(
                fontSize: 18,
                fontFamily: FontTheme.OPEN_SANS,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Container(
                      margin: EdgeInsets.only(top: 0),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            style: TextStyle(fontWeight: FontWeight.normal),
                            children: [
                              TextSpan(text: "Jobs ", style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontTheme.OPEN_SANS,
                                fontWeight: FontWeight.w200,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              )),
                              TextSpan(text: "(limited to 4)", style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontTheme.OPEN_SANS,
                                fontWeight: FontWeight.w900,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              )),
                            ]
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Invoices',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Contracts',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Client Portal',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Mileage tracking',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Expense tracking',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Income tracking',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
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
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
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
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Custom reminders',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Locations',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Poses',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subscriptionInfo() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: 650,
          width: 396,
          margin: EdgeInsets.only(top: 24),
          padding: EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(ColorConstants.getPrimaryWhite())
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 32),
                alignment: Alignment.centerLeft,
                child: Text(
                  selections.elementAt(1) ? 'Yearly' : 'Monthly',
                  style: TextStyle(
                      fontSize: 26,
                      fontFamily: FontTheme.OPEN_SANS,
                      color: Color(ColorConstants.getPrimaryBlack()),
                      fontWeight: FontWeight.w900
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 8, top: 8),
                    child: Text(
                      selections.elementAt(1) ? '\$139.99' : '\$16.99',
                      style: TextStyle(
                          fontSize: 54,
                          fontFamily: FontTheme.OPEN_SANS,
                          color: Color(ColorConstants.getPrimaryBlack()),
                          fontWeight: FontWeight.w900
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 4),
                          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Color(selections.elementAt(1) ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite())
                          ),
                          child: Text(
                            selections.elementAt(1) ? 'SAVE 30%' : '',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontTheme.MONTSERRAT,
                                color: Color(ColorConstants.getPrimaryWhite()),
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          selections.elementAt(1) ? '( \$11.66/month )' : '/month (\$204/year)',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: FontTheme.MONTSERRAT,
                              color: Color(ColorConstants.getPrimaryBlack()),
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                alignment: Alignment.centerLeft,
                child: Text(
                  'What\'s included:',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: FontTheme.OPEN_SANS,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Container(
                          margin: EdgeInsets.only(top: 0),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                                style: TextStyle(fontWeight: FontWeight.normal),
                                children: [
                                  TextSpan(text: "Jobs ", style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FontTheme.OPEN_SANS,
                                    fontWeight: FontWeight.w200,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  )),
                                  TextSpan(text: "(Unlimited)", style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FontTheme.OPEN_SANS,
                                    fontWeight: FontWeight.w900,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  )),
                                ]
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Invoices',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Contracts',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Client Portal',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Mileage tracking',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Expense tracking',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Income tracking',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
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
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
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
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Custom reminders',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Locations',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryBlack()),),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Poses',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 2),
          height: 42,
          width: 266,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: Color(ColorConstants.getPrimaryWhite())
          ),
        ),
        ToggleButtons(
          constraints: BoxConstraints(maxHeight: 42, minHeight: 42),
          children: [
            Container(
              width: 132,
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Monthly',
                textAlign: TextAlign.center,
                color: selections.elementAt(0) ? Color(ColorConstants.getPrimaryWhite()) : Color(ColorConstants.getPeachDark()),
              ),
            ),
            Container(
              width: 132,
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Yearly',
                textAlign: TextAlign.center,
                color: selections.elementAt(1) ? Color(ColorConstants.getPrimaryWhite()) : Color(ColorConstants.getPeachDark()),
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(21),
          borderWidth: 2,
          borderColor: Color(ColorConstants.getPeachDark()),
          selectedBorderColor: Color(ColorConstants.getPeachDark()),
          fillColor: Color(ColorConstants.getPeachDark()),
          isSelected: selections,
          onPressed: (index) {
            setState(() {
              if(index == 0) {
                selections[0] = true;
                selections[1] = false;
                monthlySelected = true;
              } else {
                selections[1] = true;
                selections[0] = false;
                monthlySelected = false;
              }
            });
          },
        ),
      ],
    );
  }
}