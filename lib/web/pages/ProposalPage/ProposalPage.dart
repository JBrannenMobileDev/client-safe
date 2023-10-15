import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/web/pages/ClientPortalActions.dart';
import 'package:dandylight/web/pages/contractPage/ContractPage.dart';
import 'package:dandylight/web/pages/posesPage/ClientPosesPage.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../ClientPortalPageState.dart';
import '../detailsPage/DetailsPage.dart';
import '../invoicePage/InvoicePage.dart';

class ProposalPage extends StatefulWidget {
  final String userId;
  final String jobId;
  final bool isBrandingPreview;

  ProposalPage({this.userId, this.jobId, this.isBrandingPreview});

  @override
  State<StatefulWidget> createState() {
    return _SignContractPageState(userId, jobId, isBrandingPreview);
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
  final bool isBrandingPreview;
  final ScrollController _controller = ScrollController();

  _SignContractPageState(this.userId, this.jobId, this.isBrandingPreview);

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
            store.dispatch(SetBrandingPreviewStateAction(store.state.clientPortalPageState, isBrandingPreview));
            store.dispatch(FetchProposalDataAction(store.state.clientPortalPageState, userId, jobId, isBrandingPreview));
          },
          converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
          builder: (BuildContext context, ClientPortalPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  controller: _controller,
                  child: pageState.profile != null && pageState.proposal != null ? Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                pageState.profile?.bannerWebUrl != null && pageState.profile?.bannerMobileUrl != null && pageState.profile?.bannerImageSelected == true ? Container(
                                  height: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 : 300,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: DandyLightNetworkImage(
                                    DeviceType.getDeviceTypeByContext(context) == Type.Website ? pageState.profile.bannerWebUrl : pageState.profile.bannerMobileUrl,
                                    borderRadius: 0,
                                    resizeWidth: 2160,
                                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.bannerColor),
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
                                      boxShadow: ElevationToShadow[0],
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
                                      boxShadow: ElevationToShadow[0],
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
                                          type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                                          fontFamily: pageState.profile.selectedFontTheme.mainFont,
                                          text: pageState.job.client?.getClientFullName(),
                                          color: ColorConstants.isWhiteString(pageState.profile.selectedColorTheme.bannerColor) && !pageState.profile.bannerImageSelected ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                                          addShadow: pageState.profile.bannerImageSelected ? true : false,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: calculateCompanyNameMargin(MediaQuery.of(context).size.width)),
                                        child: TextDandyLight(
                                          type: TextDandyLight.LARGE_TEXT,
                                          fontFamily: pageState.profile.selectedFontTheme.mainFont,
                                          text: pageState.profile.businessName,
                                          color: ColorConstants.isWhiteString(pageState.profile.selectedColorTheme.bannerColor) && !pageState.profile.bannerImageSelected ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                                          addShadow: pageState.profile.bannerImageSelected ? true : false,
                                        ),
                                      )
                                    ],
                                  ),
                                ) : SizedBox(),
                              ],
                            ),
                          ) : pageState.profile?.bannerWebUrl != null && pageState.profile?.bannerMobileUrl != null && pageState.profile?.bannerImageSelected == true ? buildSmallIconLayout(pageState) : buildLargeIconLayout(pageState),
                          Container(
                            margin: EdgeInsets.only(top: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 - 124 : 264, bottom: 124),
                            width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1440 : MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                boxShadow: ElevationToShadow[DeviceType.getDeviceTypeByContext(context) == Type.Website && (!ColorConstants.isWhiteString(pageState.profile.selectedColorTheme.bannerColor) || pageState.profile.bannerImageSelected) ? 2 : 0],
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
                                _getSelectedPage(selectedPage),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : Container(),
                ),
                DeviceType.getDeviceTypeByContext(context) != Type.Website && _menuButtonsSmallScreen(pageState) != null ? _menuButtonsSmallScreen(pageState) : SizedBox()
              ],
            ),
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
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_HOME_SELECTED);
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Details',
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CONTRACT_SELECTED);
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_INVOICE_SELECTED);
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_POSES_SELECTED);
        },
        child: MouseRegion(
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
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

  Widget _menuButtonsSmallScreen(ClientPortalPageState pageState) {
    if(pageState.proposal.contract != null || pageState.invoice != null || pageState.job.poses != null && pageState.job.poses.length > 0) {
      return Container(
        height: 54,
        margin: EdgeInsets.only(left: 8, right: 8),
        padding: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor),
          boxShadow: ElevationToShadow[4],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPage = DETAILS;
                });
                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_HOME_SELECTED);
              },
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                height: 26,
                width: 26,
                child: Image.asset(
                  selectedPage == DETAILS ? "navIcons/home_solid.png" : "navIcons/home_outline.png",
                ),
              ),
            ),
            pageState.proposal.contract != null ? GestureDetector(
              onTap: () {
                setState(() {
                  selectedPage = CONTRACT;
                });
                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_INVOICE_SELECTED);
              },
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                height: 26,
                width: 26,
                child: Image.asset(
                  selectedPage == CONTRACT ? "navIcons/contract_solid.png" : "navIcons/contract_outline.png",
                ),
              ),
            ) : SizedBox(),
            pageState.invoice != null ? GestureDetector(
              onTap: () {
                setState(() {
                  selectedPage = INVOICE;
                });
                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_INVOICE_SELECTED);
              },
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                height: 26,
                width: 26,
                child: Image.asset(
                  selectedPage == INVOICE ? "navIcons/invoice_solid.png" : "navIcons/invoice_outline.png",
                ),
              ),
            ) : SizedBox(),
            pageState.job.poses != null && pageState.job.poses.length > 0 ? GestureDetector(
              onTap: () {
                setState(() {
                  selectedPage = POSES;
                });
                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_POSES_SELECTED);
              },
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                height: 26,
                width: 26,
                child: Image.asset(
                  selectedPage == POSES ? "navIcons/image_solid.png" : "navIcons/image_outline.png",
                ),
              ),
            ) : SizedBox(),
          ],
        ),
      );
    } else {
      return null;
    }
  }

  _getSelectedPage(String selectedPage) {
    Widget result = DetailsPage();
    switch(selectedPage) {
      case DETAILS:
        result = DetailsPage();
        break;
      case CONTRACT:
        result = ContractPage(scrollController: _controller);
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

  Widget buildSmallIconLayout(ClientPortalPageState pageState) {
    return Stack(
      alignment: Alignment.center,
      children: [
        pageState.profile?.bannerWebUrl != null && pageState.profile?.bannerMobileUrl != null && pageState.profile?.bannerImageSelected == true ? Container(
          height: 300,
          child: DandyLightNetworkImage(
            DeviceType.getDeviceTypeByContext(context) == Type.Website ? pageState.profile.bannerWebUrl : pageState.profile.bannerMobileUrl,
            borderRadius: 0,
            color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.bannerColor),
          ),
        ) : Container(
          height: 300,
          decoration: BoxDecoration(
            color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.bannerColor),
          ),
        ),
        Container(
          height: 300,
          width: double.infinity,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pageState.profile?.logoUrl != null  && pageState.profile.logoSelected ? Container(
                alignment: Alignment.center,
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  boxShadow: ElevationToShadow[0],
                  shape: BoxShape.circle,
                  color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(21.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                    ),
                    width: 42,
                    height: 42,
                    child: DandyLightNetworkImage(
                      pageState.profile.logoUrl,
                      color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                    ),
                  ),
                ),
              ) : Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                        boxShadow: ElevationToShadow[4],
                    ),
                  ),
                  TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    fontFamily: pageState.profile.selectedFontTheme.iconFont,
                    textAlign: TextAlign.center,
                    text: pageState.profile.logoCharacter,
                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconTextColor),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: pageState.profile.businessName,
                  fontFamily: pageState.profile.selectedFontTheme.mainFont,
                  textAlign: TextAlign.center,
                  color: ColorConstants.isWhiteString(pageState.profile.selectedColorTheme.bannerColor) && !pageState.profile.bannerImageSelected ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                  addShadow: pageState.profile.bannerImageSelected ? true : false,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_LARGE_TEXT,
            text: pageState.job.clientName,
            fontFamily: pageState.profile.selectedFontTheme.mainFont,
            textAlign: TextAlign.center,
            color: ColorConstants.isWhiteString(pageState.profile.selectedColorTheme.bannerColor) && !pageState.profile.bannerImageSelected ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
            addShadow: pageState.profile.bannerImageSelected ? true : false,
          ),
        ),
      ],
    );
  }

  Widget buildLargeIconLayout(ClientPortalPageState pageState) {
    return Container(
      height: 300,
      width: double.infinity,
      color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.bannerColor),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pageState.profile?.logoUrl != null  && pageState.profile.logoSelected ? Container(
            alignment: Alignment.center,
            height: 132,
            width: 132,
            decoration: BoxDecoration(
              boxShadow: ElevationToShadow[0],
              shape: BoxShape.circle,
              color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
            ),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(66.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                ),
                width: 132,
                height: 132,
                child: DandyLightNetworkImage(
                  pageState.profile.logoUrl,
                  color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                ),
              ),
            ),
          ) : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 132,
                width: 132,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor)
                ),
              ),
              TextDandyLight(
                type: TextDandyLight.BRAND_LOGO,
                fontFamily: pageState.profile.selectedFontTheme.iconFont,
                textAlign: TextAlign.center,
                text: pageState.profile.logoCharacter,
                color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconTextColor),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: pageState.profile.businessName,
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
              textAlign: TextAlign.center,
              color: ColorConstants.isWhiteString(pageState.profile.selectedColorTheme.bannerColor) && !pageState.profile.bannerImageSelected ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
              addShadow: pageState.profile.bannerImageSelected ? true : false,
            ),
          ),
          Container(
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: pageState.job.client?.getClientFullName(),
              textAlign: TextAlign.center,
              fontFamily: pageState.profile.selectedFontTheme.mainFont,
              color: ColorConstants.isWhiteString(pageState.profile.selectedColorTheme.bannerColor) && !pageState.profile.bannerImageSelected ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
              addShadow: pageState.profile.bannerImageSelected ? true : false,
            ),
          )
        ],
      ),
    );
  }
}