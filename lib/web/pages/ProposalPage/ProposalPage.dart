import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/web/pages/ClientPortalActions.dart';
import 'package:dandylight/web/pages/contractPage/ContractPage.dart';
import 'package:dandylight/web/pages/posesPage/ClientPosesPage.dart';
import 'package:dandylight/widgets/DividerWidget.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../pages/poses_page/PosesPage.dart';
import '../../../utils/ColorConstants.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../ClientPortalPageState.dart';
import '../detailsPage/DetailsPage.dart';
import '../invoicePage/InvoicePage.dart';

class ProposalPage extends StatefulWidget {
  final String userId;
  final String jobId;

  ProposalPage({this.userId, this.jobId});

  @override
  State<StatefulWidget> createState() {
    return _SignContractPageState(userId, jobId);
  }
}

class _SignContractPageState extends State<ProposalPage> {
  static const String DETAILS = 'details';
  static const String CONTRACT = 'contract';
  static const String INVOICE = 'invoice';
  static const String QUESTIONNAIRE = 'questionnaire';
  static const String POSES = 'poses';
  static const String FEEDBACK = 'feedback';

  final String userId;
  final String jobId;

  _SignContractPageState(this.userId, this.jobId);

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
            store.dispatch(FetchProposalDataAction(store.state.clientPortalPageState, userId, jobId));
          },
          converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
          builder: (BuildContext context, ClientPortalPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: SingleChildScrollView(
            child: pageState.profile != null && pageState.proposal != null ? Container(
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
                          pageState.profile?.bannerUrl != null && pageState.profile?.bannerImageSelected == true ? Container(
                            height: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 : 300,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: DandyLightNetworkImage(
                                pageState.profile.bannerUrl
                            ),
                          ) : Container(
                            height: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 : 300,
                            decoration: BoxDecoration(
                              color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.bannerColor),
                            ),
                          ),
                          DeviceType.getDeviceTypeByContext(context) == Type.Website && pageState.profile?.logoUrl != null && pageState.profile?.logoSelected == true ? Padding(
                            padding: EdgeInsets.only(left: calculateLogoMargin(MediaQuery.of(context).size.width), bottom: 124),
                            child: Container(
                              alignment: Alignment.center,
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                boxShadow: ElevationToShadow[4],
                                shape: BoxShape.circle,
                                color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                              ),
                              child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(75.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                                      ),
                                      width: 150,
                                      height: 150,
                                      child: DandyLightNetworkImage(
                                          pageState.profile.logoUrl,
                                          color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                                      ),
                                ),
                              ),
                            ),
                          ) : SizedBox(),
                          DeviceType.getDeviceTypeByContext(context) == Type.Website && pageState.profile?.logoSelected == false ? Padding(
                            padding: EdgeInsets.only(left: calculateLogoMargin(MediaQuery.of(context).size.width), bottom: 124),
                            child: Container(
                              alignment: Alignment.center,
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    boxShadow: ElevationToShadow[4],
                                    shape: BoxShape.circle,
                                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                                ),
                              child: TextDandyLight(
                                type: TextDandyLight.BRAND_LOGO,
                                text: pageState.profile.logoCharacter,
                                fontFamily: pageState.profile.selectedFontTheme.iconFont,
                                color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconTextColor),
                              ),
                            ),
                          ) : SizedBox(),
                          DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                            margin: EdgeInsets.only(bottom: 124),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: calculateCompanyNameMargin(MediaQuery.of(context).size.width)),
                                  child: TextDandyLight(
                                    type: TextDandyLight.EXTRA_LARGE_TEXT,
                                    fontFamily: pageState.profile.selectedFontTheme.titleFont,
                                    text: pageState.profile.businessName,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    addShadow: true,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: calculateCompanyNameMargin(MediaQuery.of(context).size.width)),
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    fontFamily: pageState.profile.selectedFontTheme.titleFont,
                                    text: pageState.job.client.getClientFullName(),
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
                                pageState.profile?.logoUrl != null ? Material(
                                  elevation: 4,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 124,
                                    width: 124,
                                    child: Image.asset("images/backgrounds/sample_brand.png"),
                                  ),
                                ) : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 124,
                                      width: 124,
                                      decoration: BoxDecoration(
                                        boxShadow: ElevationToShadow[4],
                                        shape: BoxShape.circle,
                                        color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                                      ),
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.BRAND_LOGO_SMALL,
                                      text: pageState.profile.logoCharacter,
                                      fontFamily: pageState.profile.selectedFontTheme.iconFont,
                                      color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconTextColor),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  child: TextDandyLight(
                                    type: TextDandyLight.EXTRA_LARGE_TEXT,
                                    text: pageState.profile.businessName,
                                    fontFamily: pageState.profile.selectedFontTheme.titleFont,
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    addShadow: true,
                                  ),
                                ),
                                Container(
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: pageState.job.client.getClientFullName(),
                                    textAlign: TextAlign.center,
                                    fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
                      margin: EdgeInsets.only(top: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 - 124 : 300, bottom: 124),
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
            ) : Container(),
          ),
        )
      );

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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal?.contract != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.invoice != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal.includePoses && pageState.job.poses.length > 0 ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal?.questionnaire != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal?.feedback != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal?.contract != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.invoice != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal?.includePoses ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal?.questionnaire != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
      pageState.proposal?.feedback != null ? GestureDetector(
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
        result = ClientPosesPage();
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