
import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/pages/share_with_client_page/ChooseMessageBottomSheet.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientActions.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/Shadows.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'ShareWithClientPageState.dart';
import 'ShareWithClientSetupBottomSheet.dart';
import 'ShareWithClientTextField.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ShareWithClientPage extends StatefulWidget {
  final Job? job;
  final bool isPreview;
  ShareWithClientPage({this.job, required this.isPreview});

  @override
  State<StatefulWidget> createState() {
    return _ShareWithClientPageState(job, isPreview);
  }
}

class _ShareWithClientPageState extends State<ShareWithClientPage> with TickerProviderStateMixin {
  final Job? job;
  Profile? profile;
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  bool isKeyboardVisible = false;
  bool initialSetupState = false;
  bool isPreview;
  _isThisPageShowing(BuildContext context) => pageContext != null && ModalRoute.of(pageContext!)?.isCurrent == true;
  BuildContext? pageContext;
  bool contractChecked = false;
  bool invoiceChecked = false;
  bool posesChecked = false;
  _isProgressDialogShowing(BuildContext context) => progressContext != null && progressContext!.mounted && ModalRoute.of(progressContext!)?.isCurrent == true;
  BuildContext? progressContext;
  late StreamSubscription<bool> keyboardSubscription;
  bool questionnairesChecked = false;

  @override
  void initState() {
    super.initState();
    contractChecked = job!.proposal!.includeContract!;
    invoiceChecked = job!.proposal!.includeInvoice!;
    posesChecked = job!.proposal!.includePoses!;
    questionnairesChecked = job!.proposal!.includeQuestionnaires!;

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          showOverlay(context);
          setState(() {
            isKeyboardVisible = true;
          });
        } else {
          removeOverlay();
          setState(() {
            isKeyboardVisible = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  _ShareWithClientPageState(this.job, this.isPreview);

  void handleClick(String value) {
    switch (value) {
      case 'Branding':
        NavigationUtil.onEditBrandingSelected(context);
        EventSender().sendEvent(eventName: EventNames.BRANDING_EDIT_FROM_SHARE);
        break;
      case 'Business Info':
        NavigationUtil.onEditProfileSelected(context, profile!);
        EventSender().sendEvent(eventName: EventNames.SETUP_BUSINESS_INFO_FROM_SHARE);
        break;
      case 'Payment Options':
        NavigationUtil.onPaymentRequestInfoSelected(context);
        EventSender().sendEvent(eventName: EventNames.SETUP_PAYMENT_OPTIONS_FROM_SHARE);
        break;
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  void _showSetupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return ShareWithClientSetupBottomSheet();
      },
    );
  }

  void _showChooseMessageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return ChooseMessageBottomSheet(_setSelectedMessage);
      },
    );
  }

  void _setSelectedMessage(String message) {
    setState(() {
      messageController.value = messageController.value.copyWith(text: message);
    });
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ShareWithClientPageState>(
        onInit: (store) async {
          profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
          pageContext = context;
          await store.dispatch(FetchProfileAction(store.state.shareWithClientPageState));
          store.dispatch(SetJobShareWithClientAction(store.state.shareWithClientPageState, job));
          String clientName = job!.client != null ? job!.client!.firstName! : 'Client';
          String clientMessage = "(Example message in client portal - DELETE THIS TEXT BEFORE SENDING TO CLIENT)\n\nHi ${clientName},\nI wanted to thank you again for choosing our photography services. We're excited to work with you to capture your special moments.\n\nTo make things official, kindly review and sign the contract. It outlines our agreement's essential details.\n\nIf you have any questions, please don't hesitate to ask.\n\nBest regards,\n\n${profile!.firstName} ${profile!.lastName ?? ''}\n${profile!.businessName ?? ''}";
          if(job!.proposal!.detailsMessage != null && job!.proposal!.detailsMessage!.isNotEmpty) {
            messageController.value = messageController.value.copyWith(text: job!.proposal!.detailsMessage);
            store.dispatch(SetClientMessageAction(store.state.shareWithClientPageState, job!.proposal!.detailsMessage));
          } else {
            String messageToSet = '';
            List<Job> jobs = (await JobDao.getAllJobs()).where((job) => job.proposal != null && job.proposal!.detailsMessage != null && job.proposal!.detailsMessage!.isNotEmpty).toList();
            jobs = jobs.reversed.toList();
            if(jobs.isNotEmpty && jobs.elementAt(0).proposal!.detailsMessage != null) {
              messageToSet = jobs.elementAt(0).proposal!.detailsMessage!;
            } else {
              messageToSet = clientMessage;
            }
            store.dispatch(SetClientMessageAction(store.state.shareWithClientPageState, messageToSet));
            messageController.value = messageController.value.copyWith(text: messageToSet);
          }

          setState(() {
            initialSetupState = !profile!.isProfileComplete() || !profile!.hasSetupBrand! || !profile!.paymentOptionsSelected();
          });
          EventSender().setUserProfileData(EventNames.IS_PORTAL_SETUP_COMPLETE, !initialSetupState);
        },
        onWillChange: (previous, current) {
          setState(() {
            profile = current.profile;
          });
        },
        onDidChange: (previous, current) {
          if(!isPreview) {
            if(initialSetupState) {
              setState(() {
                initialSetupState = false;
              });
              _showSetupSheet(context);
            } else {
              if(previous!.profile != null && current.profile != null) {
                bool shouldShowCurrent = !current.profile!.isProfileComplete() || !current.profile!.hasSetupBrand! || !current.profile!.paymentOptionsSelected();
                bool shouldShowPrevious = !previous.profile!.isProfileComplete() || !previous.profile!.hasSetupBrand! || !previous.profile!.paymentOptionsSelected();
                if(shouldShowCurrent && !shouldShowPrevious) {
                  if(_isThisPageShowing(context)) {
                    _showSetupSheet(context);
                  }
                }
              }
            }
          }

          if(progressContext != null && _isProgressDialogShowing(context) && !current.updatePosesCheckInProgress! && !current.updateInvoiceCheckInProgress! && !current.updateContractCheckInProgress! && !current.updateQuestionnairesCheckInProgress!) {
            Navigator.of(context).pop();
            IntentLauncherUtil.launchBrandingPreviewURL(UidUtil().getUid(), job!.documentId!);
            EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_PREVIEW_SELECTED);
            EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_PREVIEW_SELECTED, properties: {
              EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_INVOICE : invoiceChecked,
              EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_CONTRACT : contractChecked,
              EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_POSES : posesChecked,
              EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_QUESTIONNAIRES : questionnairesChecked,
              EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_LINK : 'https://dandylight.com/clientPortal/${profile!.uid}+${job!.documentId}',
            });
          }
        },
        converter: (Store<AppState> store) => ShareWithClientPageState.fromStore(store),
        builder: (BuildContext context, ShareWithClientPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
                    backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    pinned: true,
                    centerTitle: true,
                    surfaceTintColor: Colors.transparent,
                    title: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: "Share With Client",
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    actions: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: handleClick,
                        padding: const EdgeInsets.only(right: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        itemBuilder: (BuildContext context) {
                          return {'Branding', 'Business Info', 'Payment Options'}.map((String choice) {
                            Widget icon = const SizedBox();
                            switch (choice) {
                              case 'Branding':
                                icon = Image.asset('assets/images/icons/art.png');
                                break;
                              case 'Business Info':
                                icon = Image.asset('assets/images/icons/profile_icon_black.png');
                                break;
                              case 'Payment Options':
                                icon = Image.asset('assets/images/collection_icons/pricing_profile_icons/wallet_icon_white.png', color: Color(ColorConstants.getPrimaryBlack()),);
                                break;
                            }
                            icon = Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 18.0, left: 2.0),
                                  height: 28.0,
                                  width: 28.0,
                                  child: icon,
                                );
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  icon,
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: choice,
                                  )
                                ],
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 32, bottom: 8),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              textAlign: TextAlign.center,
                              text: 'Client Portal message to Client',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                height: 264,
                                margin: const EdgeInsets.only(left: 16, right: 16),
                                padding: const EdgeInsets.only(top: 16),
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    borderRadius: BorderRadius.circular(24)
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: ShareWithClientTextField(
                                    messageController,
                                    '',
                                    TextInputType.multiline,
                                    200.0,
                                    pageState.onMessageChanged,
                                    'noError',
                                    TextInputAction.newline,
                                    _messageFocusNode,
                                    onAction,
                                    TextCapitalization.sentences,
                                    null,
                                    true,
                                    false,
                                    false,
                                  ),
                                ),
                              ),
                              profile != null && profile!.jobsCreatedCount! > 1 ? GestureDetector(
                                onTap: () {
                                  _showChooseMessageSheet(context);
                                },
                                child: !isKeyboardVisible ? Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  width: 264,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Color(ColorConstants.getPeachDark()),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        child: Image.asset('assets/images/icons/previous.png', color: Color(ColorConstants.getPrimaryWhite())),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Load from previous',
                                        textAlign: TextAlign.center,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      )
                                    ],
                                  ) ,
                                ) : const SizedBox(),
                              ) : const SizedBox()
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 32, bottom: 8),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              textAlign: TextAlign.center,
                              text: 'Select Items to Share',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Container(
                            height: 276,
                            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 264),
                            padding: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(24)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  alignment: Alignment.center,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36.0)),
                                  child: CheckboxListTile(
                                    title: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Job Details',
                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    ),
                                    tileColor: Color(ColorConstants.getPrimaryGreyMedium()),
                                    value: true,
                                    activeColor: Color(ColorConstants.getPrimaryGreyMedium()),
                                    onChanged: (selected) {

                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  alignment: Alignment.center,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36.0)),
                                  child: CheckboxListTile(
                                    title: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Contract',
                                    ),
                                    value: contractChecked,
                                    activeColor: Color(ColorConstants.getPeachDark()),
                                    onChanged: (selected) {
                                      pageState.onContractCheckBoxSelected!(selected!);
                                      setState(() {
                                        contractChecked = selected;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  alignment: Alignment.center,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36.0)),
                                  child: CheckboxListTile(
                                    title: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Invoice',
                                    ),
                                    value: invoiceChecked,
                                    activeColor: Color(ColorConstants.getPeachDark()),
                                    onChanged: (selected) {
                                      pageState.onInvoiceCheckBoxSelected!(selected!);
                                      setState(() {
                                        invoiceChecked = selected;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  alignment: Alignment.center,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36.0)),
                                  child: CheckboxListTile(
                                    title: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Questionnaires',
                                    ),
                                    value: questionnairesChecked,
                                    activeColor: Color(ColorConstants.getPeachDark()),
                                    onChanged: (selected) {
                                      pageState.onQuestionnairesCheckBoxSelected!(selected ?? false);
                                      setState(() {
                                        questionnairesChecked = selected ?? false;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  alignment: Alignment.center,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(36.0)),
                                  child: CheckboxListTile(
                                    title: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Poses',
                                    ),
                                    value: posesChecked,
                                    activeColor: Color(ColorConstants.getPeachDark()),
                                    onChanged: (selected) {
                                      pageState.onPosesCheckBoxSelected!(selected!);
                                      setState(() {
                                        posesChecked = selected;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    !isKeyboardVisible ? Container(
                      width: MediaQuery.of(context).size.width/2 - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: GestureDetector(
                        onTap: () {
                          if(pageState.profile!.isProfileComplete() && pageState.profile!.hasSetupBrand! && pageState.profile!.paymentOptionsSelected()) {
                            if((pageState.updateContractCheckInProgress ?? false) || pageState.updateInvoiceCheckInProgress! || pageState.updatePosesCheckInProgress! || pageState.updateQuestionnairesCheckInProgress!) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  progressContext = context;
                                  return AlertDialog(
                                    title: TextDandyLight(
                                      textAlign: TextAlign.center,
                                      text: 'Saving changes...',
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    titlePadding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                                    contentPadding: const EdgeInsets.all(0),
                                    content: Container(
                                      height: 96,
                                      width: 250,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: LoadingAnimationWidget.fourRotatingDots(
                                        color: Color(ColorConstants.getPeachDark()),
                                        size: 48,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              if(_isProgressDialogShowing(context)) Navigator.of(context).pop();
                              pageState.saveProposal!();
                              IntentLauncherUtil.launchBrandingPreviewURL(UidUtil().getUid(), job!.documentId!);
                              EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_PREVIEW_SELECTED);
                              EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_PREVIEW_SELECTED, properties: {
                                EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_INVOICE : invoiceChecked,
                                EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_CONTRACT : contractChecked,
                                EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_POSES : posesChecked,
                                EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_QUESTIONNAIRES : questionnairesChecked,
                                EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_LINK : 'https://dandylight.com/clientPortal/${profile!.uid}+${job!.documentId}',
                              });
                            }
                          } else {
                            String toastMessage = '';
                            if(!pageState.profile!.isProfileComplete()) {
                              toastMessage = 'Please complete your profile first.';
                            } else if(!pageState.profile!.hasSetupBrand!) {
                              toastMessage = 'Please setup your brand first.';
                            }
                            DandyToastUtil.showErrorToast(toastMessage);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 54,
                          width: MediaQuery.of(context).size.width/2 - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                          margin: const EdgeInsets.only(left: 32, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Color(ColorConstants.getPeachDark()),
                            boxShadow: ElevationToShadow[4],
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'Preview',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                    ) : const SizedBox(),
                    !isKeyboardVisible ? Container(
                      width: MediaQuery.of(context).size.width/2 - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: GestureDetector(
                        onTap: () {
                          pageState.saveProposal!();
                          String emailTitle = pageState.profile!.businessName != null && pageState.profile!.businessName!.isNotEmpty ? '${pageState.profile!.businessName} - Session details' : pageState.profile!.firstName != null && pageState.profile!.firstName!.isNotEmpty ? '${pageState.profile!.firstName} - Session details' : 'Session details';
                          UserOptionsUtil.showShareClientPortalOptionsSheet(context, pageState.job!.client!,  emailTitle, profile!, job!);
                          EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED, properties: {
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_INVOICE : pageState.invoiceSelected ?? false,
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_CONTRACT : pageState.contractSelected ?? false,
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_POSES : pageState.posesSelected ?? false,
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_QUESTIONNAIRES : pageState.questionnairesSelected ?? false,
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_LINK : 'https://dandylight.com/clientPortal/${profile!.uid}+${job!.documentId}',
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 54,
                          width: MediaQuery.of(context).size.width/2 - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                          margin: const EdgeInsets.only(left: 8, right: 32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Color(ColorConstants.getPeachDark()),
                            boxShadow: ElevationToShadow[4],
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'Share',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                    ) : const SizedBox()
                  ],
                ),
              )
              ,
            ],
          ),
        ),
      );

  void onAction(){
    _messageFocusNode.unfocus();
  }
}
