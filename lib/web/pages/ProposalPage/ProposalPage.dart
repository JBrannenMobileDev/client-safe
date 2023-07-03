import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/web/pages/ProposalPage/ContractPage.dart';
import 'package:dandylight/widgets/DividerWidget.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';

import '../../../utils/ColorConstants.dart';
import 'DetailsPage.dart';

class ProposalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignContractPageState();
  }
}

class _SignContractPageState extends State<ProposalPage> {
  static const String DETAILS = 'details';
  static const String CONTRACT = 'contract';
  static const String INVOICE = 'invoice';
  static const String QUESTIONNAIRE = 'questionnaire';
  static const String POSES = 'poses';
  static const String FEEDBACK = 'feedback';

  String selectedPage = DETAILS;
  bool isHoveredDetails = false;
  bool isHoveredContract = false;
  bool isHoveredInvoice = false;
  bool isHoveredQuestionnaire = false;
  bool isHoveredPoses = false;
  bool isHoveredFeedback = false;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                color: Color(ColorConstants.getPrimaryWhite()),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 1440,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 300.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/backgrounds/bannerImage.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 62.5),
                            child: Material(
                              elevation: 4,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 150,
                                width: 150,
                                child: Image.asset("images/backgrounds/sample_brand.png"),
                              ),
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(left: 37.5),
                          //   height: 150,
                          //   width: 150,
                          //   decoration: BoxDecoration(
                          //       boxShadow: ElevationToShadow[4],
                          //       shape: BoxShape.circle,
                          //       color: Color(ColorConstants.getPeachDark())
                          //   ),
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 224),
                                child: TextDandyLight(
                                  type: TextDandyLight.EXTRA_LARGE_TEXT,
                                  text: 'Vintage Vibes Photography',
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  addShadow: true,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 224),
                                child: TextDandyLight(
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: 'Jason Bent',
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  addShadow: true,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    DeviceType.getDeviceTypeByContext(context) == Type.Website ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _menuButtons(),
                          ),
                        ),
                        _getSelectedPage(selectedPage),
                      ],
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _allPages(),
                    ),
                  ],
                ),
              ),
            ),
          )
      );

  List<Widget> _allPages() {
    return [
      DetailsPage(),
      DividerWidget(),
      ContractPage(),
    ];
  }

  List<Widget> _menuButtons() {
    return [
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = DETAILS;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Details',
              isBold: isHoveredDetails || selectedPage == DETAILS,
              color: Colors.black,
            ),
          ),
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHoveredDetails = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHoveredDetails = false;
            });
          },
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = CONTRACT;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Contract',
              isBold: isHoveredContract || selectedPage == CONTRACT,
            ),
          ),
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHoveredContract = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHoveredContract = false;
            });
          },
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = INVOICE;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Invoice',
              isBold: isHoveredInvoice || selectedPage == INVOICE,
            ),
          ),
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHoveredInvoice = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHoveredInvoice = false;
            });
          },
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = QUESTIONNAIRE;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Questionnaire',
              isBold: isHoveredQuestionnaire || selectedPage == QUESTIONNAIRE,
            ),
          ),
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHoveredQuestionnaire = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHoveredQuestionnaire = false;
            });
          },
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = POSES;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Poses',
              isBold: isHoveredPoses || selectedPage == POSES,
            ),
          ),
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHoveredPoses = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHoveredPoses = false;
            });
          },
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = FEEDBACK;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Feedback',
              isBold: isHoveredFeedback || selectedPage == FEEDBACK,
            ),
          ),
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHoveredFeedback = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHoveredFeedback = false;
            });
          },
        ),
      ),
    ];
  }

  _getSelectedPage(String selectedPage) {
    Widget result = DetailsPage();
    switch(selectedPage) {
      case DETAILS:
        result = DetailsPage();
        break;
      case CONTRACT:
        result = ContractPage();
        break;
      case INVOICE:
        result = DetailsPage();
        break;
      case QUESTIONNAIRE:
        result = DetailsPage();
        break;
      case POSES:
        result = DetailsPage();
        break;
      case FEEDBACK:
        result = DetailsPage();
        break;
    }
    return result;
  }
}