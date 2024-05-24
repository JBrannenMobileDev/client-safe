import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/web/pages/ClientPortalActions.dart';
import 'package:dandylight/web/pages/contractPage/ContractPage.dart';
import 'package:dandylight/web/pages/posesPage/ClientPosesPage.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../ClientPortalPageState.dart';
import '../contractPage/ContractsPageWeb.dart';
import '../detailsPage/DetailsPage.dart';
import '../invoicePage/InvoicePage.dart';
import '../questionnairesPage/ClientPortalQuestionnairesPage.dart';

class ProposalPage extends StatefulWidget {
  final String? userId;
  final String? jobId;
  final bool? isBrandingPreview;

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

  final String? userId;
  final String? jobId;
  final bool? isBrandingPreview;
  final ScrollController? _controller = ScrollController();

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
          builder: (BuildContext context, ClientPortalPageState pageState) => PopScope(
              canPop: false,
              child: Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: pageState.isLoadingInitial! ? Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 56.0,
              width: 56.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Color(ColorConstants.getPeachDark()),
                size: 32,
              ),
            ),
          ) : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  controller: _controller,
                  child: pageState.profile != null && pageState.proposal != null ? Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          DeviceType.getDeviceTypeByContext(context) == Type.Website ? SizedBox(
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                pageState.profile!.bannerWebUrl != null && pageState.profile!.bannerMobileUrl != null && pageState.profile!.bannerImageSelected == true ? Container(
                                  height: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 : 300,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: DandyLightNetworkImage(
                                    DeviceType.getDeviceTypeByContext(context) == Type.Website ? pageState.profile!.bannerWebUrl ?? '' : pageState.profile!.bannerMobileUrl ?? '',
                                    borderRadius: 0,
                                    resizeWidth: 2160,
                                    color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.bannerColor!),
                                  ),
                                ) : Container(
                                  height: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 : 300,
                                  decoration: BoxDecoration(
                                    color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.bannerColor!),
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
                                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(75.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                                        ),
                                        width: 150,
                                        height: 150,
                                        child: DandyLightNetworkImage(
                                          pageState.profile!.logoUrl ?? '',
                                          color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : const SizedBox(),
                                DeviceType.getDeviceTypeByContext(context) == Type.Website && pageState.profile?.logoSelected == false ? Padding(
                                  padding: EdgeInsets.only(left: calculateLogoMargin(MediaQuery.of(context).size.width), bottom: 124),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      boxShadow: ElevationToShadow[0],
                                      shape: BoxShape.circle,
                                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                                    ),
                                    child: TextDandyLight(
                                      type: TextDandyLight.BRAND_LOGO,
                                      text: pageState.profile!.logoCharacter,
                                      fontFamily: pageState.profile!.selectedFontTheme!.iconFont,
                                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconTextColor!),
                                    ),
                                  ),
                                ) : const SizedBox(),
                                DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                                  margin: const EdgeInsets.only(bottom: 124),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: calculateCompanyNameMargin(MediaQuery.of(context).size.width)),
                                        child: TextDandyLight(
                                          type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                                          fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                                          text: pageState.job!.client?.getClientFullName(),
                                          color: ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.bannerColor!) && !pageState.profile!.bannerImageSelected! ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                                          addShadow: pageState.profile!.bannerImageSelected! ? true : false,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: calculateCompanyNameMargin(MediaQuery.of(context).size.width)),
                                        child: TextDandyLight(
                                          type: TextDandyLight.LARGE_TEXT,
                                          fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                                          text: pageState.profile!.businessName ?? 'Your Business Name',
                                          color: ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.bannerColor!) && !pageState.profile!.bannerImageSelected! ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                                          addShadow: pageState.profile!.bannerImageSelected! ? true : false,
                                        ),
                                      )
                                    ],
                                  ),
                                ) : const SizedBox(),
                              ],
                            ),
                          // ) : pageState.profile?.bannerWebUrl != null && pageState.profile?.bannerMobileUrl != null && pageState.profile?.bannerImageSelected == true ? buildSmallIconLayout(pageState) : buildLargeIconLayout(pageState),
                          ) : buildLargeIconLayout(pageState),
                          Container(
                            margin: EdgeInsets.only(top: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MediaQuery.of(context).size.height/2 - 124 : 264, bottom: 124),
                            width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1440 : MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                boxShadow: ElevationToShadow[DeviceType.getDeviceTypeByContext(context) == Type.Website && (!ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.bannerColor!) || pageState.profile!.bannerImageSelected!) ? 2 : 0],
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: DeviceType.getDeviceTypeByContext(context) == Type.Website ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _menuButtons(pageState),
                                ),
                                _getSelectedPage(selectedPage, pageState),
                              ],
                            ) : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _getSelectedPage(selectedPage, pageState),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : Container(),
                ),
                DeviceType.getDeviceTypeByContext(context) != Type.Website ? _menuButtonsSmallScreen(pageState) : const SizedBox()
              ],
            ),
          ),
        ),
          ),
      );

  List<Widget> _menuButtons(ClientPortalPageState pageState) {
    return [
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = DETAILS;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_HOME_SELECTED);
        },
        child: MouseRegion(
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
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Details',
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              isBold: isHoveredDetails || selectedPage == DETAILS,
              color: Colors.black,
            ),
          ),
        ),
      ),
      pageState.proposal?.contracts != null && pageState.proposal!.contracts!.isNotEmpty ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = CONTRACT;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CONTRACT_SELECTED);
        },
        child: MouseRegion(
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
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              text: 'Contract',
              isBold: isHoveredContract || selectedPage == CONTRACT,
            ),
          ),
        ),
      ) : const SizedBox(),
      pageState.invoice != null ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = INVOICE;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_INVOICE_SELECTED);
        },
        child: MouseRegion(
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
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              text: 'Invoice',
              isBold: isHoveredInvoice || selectedPage == INVOICE,
            ),
          ),
        ),
      ) : const SizedBox(),
      pageState.proposal!.includePoses! && pageState.job!.poses!.isNotEmpty ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = POSES;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_POSES_SELECTED);
        },
        child: MouseRegion(
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
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              text: 'Poses',
              isBold: isHoveredPoses || selectedPage == POSES,
            ),
          ),
        ),
      ) : const SizedBox(),
      (pageState.proposal!.includeQuestionnaires ?? false) && pageState.proposal?.questionnaires != null ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = QUESTIONNAIRE;
            _controller!.jumpTo(0);
          });
        },
        child: MouseRegion(
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
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              text: 'Questionnaire',
              isBold: isHoveredQuestionnaire || selectedPage == QUESTIONNAIRE,
            ),
          ),
        ),
      ) : const SizedBox(),
      pageState.proposal?.feedback != null ? GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = FEEDBACK;
          });
        },
        child: MouseRegion(
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
          child: Container(
            alignment: Alignment.center,
            height: 64,
            width: 150,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              text: 'Feedback',
              isBold: isHoveredFeedback || selectedPage == FEEDBACK,
            ),
          ),
        ),
      ) : const SizedBox(),
    ];
  }

  List<Widget> buildButtonList(ClientPortalPageState pageState) {
    List<Widget> result = [GestureDetector(
      onTap: () {
        setState(() {
          selectedPage = DETAILS;
          _controller!.jumpTo(0);
        });
        EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_HOME_SELECTED);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        height: 26,
        width: 26,
        child: Image.asset(
          selectedPage == DETAILS ? "navIcons/home_solid.png" : "navIcons/home_outline.png",
        ),
      ),
    )];

    if(pageState.proposal?.contracts != null && pageState.proposal!.contracts!.isNotEmpty && pageState.proposal!.includeContract!) {
      result.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = CONTRACT;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CONTRACT_SELECTED);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: 26,
          width: 26,
          child: Image.asset(
            selectedPage == CONTRACT ? "navIcons/contract_solid.png" : "navIcons/contract_outline.png",
          ),
        ),
      ));
    }

    if(pageState.invoice != null && pageState.proposal!.includeInvoice!) {
      result.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = INVOICE;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_INVOICE_SELECTED);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: 26,
          width: 26,
          child: Image.asset(
            selectedPage == INVOICE ? "navIcons/invoice_solid.png" : "navIcons/invoice_outline.png",
          ),
        ),
      ));
    }

    if(pageState.proposal!.questionnaires != null && pageState.proposal!.questionnaires!.isNotEmpty && (pageState.proposal!.includeQuestionnaires ?? false)) {
      result.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = QUESTIONNAIRE;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_QUESTIONNAIRE_SELECTED);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: 26,
          width: 26,
          child: Image.asset(
            selectedPage == QUESTIONNAIRE ? "navIcons/questionnaire_solid.png" : "navIcons/questionnaire_thin.png",
          ),
        ),
      ));
    }

    if(pageState.job!.poses != null && pageState.job!.poses!.isNotEmpty && pageState.proposal!.includePoses!) {
      result.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = POSES;
            _controller!.jumpTo(0);
          });
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_POSES_SELECTED);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: 26,
          width: 26,
          child: Image.asset(
            selectedPage == POSES ? "navIcons/image_solid.png" : "navIcons/image_outline.png",
          ),
        ),
      ));
    }

    return result;
  }

  Widget _menuButtonsSmallScreen(ClientPortalPageState pageState) {
    if((pageState.proposal?.contracts != null && pageState.proposal!.contracts!.isNotEmpty && pageState.proposal!.includeContract!) || (pageState.invoice != null && pageState.proposal!.includeInvoice!) || (pageState.job!.poses != null && pageState.job!.poses!.isNotEmpty && pageState.proposal!.includePoses!) || (pageState.proposal!.questionnaires != null && pageState.proposal!.questionnaires!.isNotEmpty && (pageState.proposal!.includeQuestionnaires ?? false))) {
      List<Widget> buttons = buildButtonList(pageState);
      return UnconstrainedBox(
        child: Container(
          alignment: Alignment.center,
          height: 54,
          margin: const EdgeInsets.only(left: 8, right: 8),
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!),
            boxShadow: ElevationToShadow[4],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  _getSelectedPage(String selectedPage, ClientPortalPageState pageState) {
    Widget result = DetailsPage();
    bool hasOldContract = pageState.proposal!.contract != null;
    switch(selectedPage) {
      case DETAILS:
        result = DetailsPage();
        break;
      case CONTRACT:
        if(hasOldContract) {
          result = ContractPage(scrollController: _controller, contract: pageState.proposal!.contract);
        } else {
          result = (pageState.proposal!.contracts?.length ?? 0) > 1 ? ContractsPageWeb(scrollController: _controller) : ContractPage(scrollController: _controller, contract: contract);
        }
        break;
      case INVOICE:
        result = InvoicePage();
        break;
      case QUESTIONNAIRE:
        result = ClientPortalQuestionnairesPage();
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
        pageState.profile?.bannerWebUrl != null && pageState.profile?.bannerMobileUrl != null && pageState.profile?.bannerImageSelected == true ? SizedBox(
          height: 300,
          child: DandyLightNetworkImage(
            DeviceType.getDeviceTypeByContext(context) == Type.Website ? pageState.profile!.bannerWebUrl ?? '' : pageState.profile!.bannerMobileUrl ?? '',
            borderRadius: 0,
            color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.bannerColor!),
          ),
        ) : Container(
          height: 300,
          decoration: BoxDecoration(
            color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.bannerColor!),
          ),
        ),
        Container(
          height: 300,
          width: double.infinity,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pageState.profile?.logoUrl != null  && pageState.profile!.logoSelected! ? Container(
                alignment: Alignment.center,
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  boxShadow: ElevationToShadow[0],
                  shape: BoxShape.circle,
                  color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                    ),
                    width: 42,
                    height: 42,
                    child: DandyLightNetworkImage(
                      pageState.profile!.logoUrl ?? '',
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
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
                        color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                        boxShadow: ElevationToShadow[1],
                    ),
                  ),
                  Container(
                    margin: getMargin(pageState.profile!.selectedFontTheme!.iconFont!),
                    child: TextDandyLight(
                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                      fontFamily: pageState.profile!.selectedFontTheme!.iconFont,
                      textAlign: TextAlign.center,
                      text: pageState.profile!.logoCharacter,
                      isMobileWeb: true,
                      color: ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.iconColor!) ? Color(ColorConstants.getPrimaryBlack()) : ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconTextColor!),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: pageState.profile!.businessName ?? 'Your Business Name',
                  fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                  textAlign: TextAlign.center,
                  color: ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.bannerColor!) && !pageState.profile!.bannerImageSelected! ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                  addShadow: pageState.profile!.bannerImageSelected! ? true : false,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_LARGE_TEXT,
            text: pageState.job!.clientName,
            fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
            textAlign: TextAlign.center,
            color: ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.bannerColor!) && !pageState.profile!.bannerImageSelected! ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
            addShadow: pageState.profile!.bannerImageSelected! ? true : false,
          ),
        ),
      ],
    );
  }

  Widget buildLargeIconLayout(ClientPortalPageState pageState) {
    return Stack(
      children: [
        pageState.profile?.bannerWebUrl != null && pageState.profile?.bannerMobileUrl != null && pageState.profile?.bannerImageSelected == true ? SizedBox(
          height: 300,
          child: DandyLightNetworkImage(
            DeviceType.getDeviceTypeByContext(context) == Type.Website ? pageState.profile!.bannerWebUrl ?? '' : pageState.profile!.bannerMobileUrl ?? '',
            borderRadius: 0,
            color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.bannerColor!),
          ),
        ) : Container(
          height: 300,
          decoration: BoxDecoration(
            color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.bannerColor!),
          ),
        ),
        Container(
          height: 300,
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pageState.profile?.logoUrl != null  && pageState.profile!.logoSelected! ? Container(
                alignment: Alignment.center,
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(66.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                      boxShadow: ElevationToShadow[1],
                    ),
                    width: 96,
                    height: 96,
                    child: DandyLightNetworkImage(
                      pageState.profile!.logoUrl ?? '',
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                    ),
                  ),
                ),
              ) : Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                      boxShadow: ElevationToShadow[1],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 96,
                    width: 96,
                    child: TextDandyLight(
                      type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.BRAND_LOGO : TextDandyLight.BRAND_LOGO_SMALL,
                      fontFamily: pageState.profile!.selectedFontTheme!.iconFont!,
                      textAlign: TextAlign.center,
                      text: pageState.profile!.logoCharacter,
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconTextColor!),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: TextDandyLight(
                  type: TextDandyLight.EXTRA_LARGE_TEXT,
                  text: pageState.job!.client?.getClientFullName(),
                  textAlign: TextAlign.center,
                  fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                  color: ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.bannerColor!) && !pageState.profile!.bannerImageSelected! ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                  addShadow: pageState.profile!.bannerImageSelected! ? true : false,
                ),
              ),
              TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: pageState.profile!.businessName ?? 'Your Business Name',
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                textAlign: TextAlign.center,
                color: ColorConstants.isWhiteString(pageState.profile!.selectedColorTheme!.bannerColor!) && !pageState.profile!.bannerImageSelected! ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryWhite()),
                addShadow: pageState.profile!.bannerImageSelected! ? true : false,
              ),
            ],
          ),
        )
      ],
    );
  }

  EdgeInsets getMargin(String iconFont) {
    if(iconFont == FontTheme.SIGNATURE1) {
      return const EdgeInsets.only(bottom: 16, left: 10);
    }

    if(iconFont == FontTheme.SIGNATURE2) {
      return const EdgeInsets.only(bottom: 6, left: 4);
    }

    if(iconFont == FontTheme.SIGNATURE3) {
      return const EdgeInsets.only(top: 4);
    }

    return const EdgeInsets.all(0);
  }
}