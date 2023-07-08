import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/web/pages/ClientPortalActions.dart';
import 'package:dandylight/web/pages/contractPage/ContractPage.dart';
import 'package:dandylight/widgets/DividerWidget.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../ClientPortalPageState.dart';
import '../detailsPage/DetailsPage.dart';
import '../invoicePage/InvoicePage.dart';

class ProposalPage extends StatefulWidget {
  final String proposalId;

  ProposalPage({this.proposalId});

  @override
  State<StatefulWidget> createState() {
    return _SignContractPageState(proposalId);
  }
}

class _SignContractPageState extends State<ProposalPage> {
  static const String DETAILS = 'details';
  static const String CONTRACT = 'contract';
  static const String INVOICE = 'invoice';
  static const String QUESTIONNAIRE = 'questionnaire';
  static const String POSES = 'poses';
  static const String FEEDBACK = 'feedback';

  final String proposalId;

  _SignContractPageState(this.proposalId);

  String selectedPage = DETAILS;
  bool isHoveredDetails = false;
  bool isHoveredContract = false;
  bool isHoveredInvoice = false;
  bool isHoveredQuestionnaire = false;
  bool isHoveredPoses = false;
  bool isHoveredFeedback = false;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientPortalPageState>(
          onInit: (store) {
            store.dispatch(FetchProposalAction(store.state.clientPortalPageState, proposalId));
          },
          converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
          builder: (BuildContext context, ClientPortalPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                color: Color(ColorConstants.getPrimaryWhite()),
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 : 300,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/backgrounds/largebackground.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          DeviceType.getDeviceTypeByContext(context) == Type.Website && pageState.proposal.logoUrl != null ? Padding(
                            padding: EdgeInsets.only(left: calculateLogoMargin(MediaQuery.of(context).size.width), bottom: 64),
                            child: Material(
                              elevation: 4,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 150,
                                width: 150,
                                child: Image.asset("images/backgrounds/sample_brand.png"),//TODO use actual image file
                              ),
                            ),
                          ) : SizedBox(),
                          DeviceType.getDeviceTypeByContext(context) == Type.Website && pageState.proposal.logoUrl == null ? Padding(
                            padding: EdgeInsets.only(left: calculateLogoMargin(MediaQuery.of(context).size.width), bottom: 64),
                            child: Container(
                              alignment: Alignment.center,
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    boxShadow: ElevationToShadow[4],
                                    shape: BoxShape.circle,
                                    color: Color(ColorConstants.getPeachDark())
                                ),
                              child: TextDandyLight(
                                type: TextDandyLight.BRAND_LOGO,
                                text: pageState.proposal.profile.businessName.substring(0, 1),
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ) : SizedBox(),
                          DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                            margin: EdgeInsets.only(bottom: 64),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: calculateCompanyNameMargin(MediaQuery.of(context).size.width)),
                                  child: TextDandyLight(
                                    type: TextDandyLight.EXTRA_LARGE_TEXT,
                                    text: pageState.proposal.profile.businessName,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    addShadow: true,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: calculateCompanyNameMargin(MediaQuery.of(context).size.width)),
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: pageState.proposal.job.client.getClientFullName(),
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    addShadow: true,
                                  ),
                                )
                              ],
                            ),
                          ) : Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                pageState.proposal.logoUrl != null ? Material(
                                  elevation: 4,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 124,
                                    width: 124,
                                    child: Image.asset("images/backgrounds/sample_brand.png"),
                                  ),
                                ) : Container(
                                  alignment: Alignment.center,
                                  height: 124,
                                  width: 124,
                                  decoration: BoxDecoration(
                                      boxShadow: ElevationToShadow[4],
                                      shape: BoxShape.circle,
                                      color: Color(ColorConstants.getPeachDark())
                                  ),
                                  child: TextDandyLight(
                                    type: TextDandyLight.BRAND_LOGO,
                                    text: pageState.proposal.profile.businessName.substring(0, 1),
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.EXTRA_LARGE_TEXT,
                                    text: 'Vintage Vibes Photography',
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    addShadow: true,
                                  ),
                                ),
                                Container(
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Jason Bent',
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    addShadow: true,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 - 64 : 300, bottom: 124),
                      width: 1440,
                      decoration: BoxDecoration(
                        boxShadow: ElevationToShadow[2],
                        color: Color(ColorConstants.getPrimaryWhite()),
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: DeviceType.getDeviceTypeByContext(context) == Type.Website ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _menuButtons(pageState),
                            ),
                          ),
                          _getSelectedPage(selectedPage),
                        ],
                      ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _menuButtonsSmallScreen(pageState),
                            ),
                          ),
                        ),
                        _getSelectedPage(selectedPage),
                      ],
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      );

  List<Widget> _allPages() {
    return [
      DetailsPage(),
      DividerWidget(width: 1080),
      ContractPage(),
      DividerWidget(width: 1080),
      InvoicePage(),
      DividerWidget(width: 1080),
    ];
  }

  List<Widget> _menuButtons(ClientPortalPageState pageState) {
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
      pageState.proposal.contract != null ? GestureDetector(
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
      ) : SizedBox(),
      pageState.proposal.invoice != null ? GestureDetector(
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
      ) : SizedBox(),
      pageState.proposal.includePoses ? GestureDetector(
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
      ) : SizedBox(),
      pageState.proposal.questionnaire != null ? GestureDetector(
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
      ) : SizedBox(),
      pageState.proposal.feedback != null ? GestureDetector(
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
      ) : SizedBox(),
    ];
  }

  List<Widget> _menuButtonsSmallScreen(ClientPortalPageState pageState) {
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
            width: 100,
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
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
      pageState.proposal.contract != null ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = CONTRACT;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 100,
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
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
      ) : SizedBox(),
      pageState.proposal.invoice != null ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = INVOICE;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 100,
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
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
      ) : SizedBox(),
      pageState.proposal.includePoses ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = POSES;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 100,
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
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
      ) : SizedBox(),
      pageState.proposal.questionnaire != null ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = QUESTIONNAIRE;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 100,
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
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
      ) : SizedBox(),
      pageState.proposal.feedback != null ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = FEEDBACK;
          });
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 100,
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
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
      ) : SizedBox(),
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
        result = InvoicePage();
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

  calculateLogoMargin(double width) {
    return ((width - 1080)/2).abs();
  }

  calculateCompanyNameMargin(double width) {
    return (((width - 1080)/2) + 172).abs();
  }
}