import 'dart:async';

import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import '../../widgets/TextDandyLight.dart';
import '../AppState.dart';
import '../models/Profile.dart';
import '../pages/new_invoice_page/InputDoneView.dart';
import '../pages/share_with_client_page/ChooseShareMessageBottomSheet.dart';
import '../pages/share_with_client_page/ShareWithClientActions.dart';
import '../pages/share_with_client_page/ShareWithClientPageState.dart';
import '../pages/share_with_client_page/ShareWithClientTextField.dart';
import 'DandyToastUtil.dart';
import 'intentLauncher/IntentLauncherUtil.dart';

class ShareClientPortalOptionsBottomSheet extends StatefulWidget {
  final Client? client;
  final String? emailTitle;
  final Profile? profile;
  final Job? job;

  const ShareClientPortalOptionsBottomSheet(this.client, this.emailTitle, this.profile, this.job, {Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _ShareClientPortalOptionsBottomSheetPageState(client, emailTitle, profile, job);
  }
}

class _ShareClientPortalOptionsBottomSheetPageState extends State<ShareClientPortalOptionsBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  final Client? client;
  final String? emailTitle;
  final Profile? profile;
  final Job? job;
  OverlayEntry? overlayEntry;
  bool isKeyboardVisible = false;
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  _ShareClientPortalOptionsBottomSheetPageState(this.client, this.emailTitle, this.profile, this.job);

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

  void _showChooseMessageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return ChooseShareMessageBottomSheet(_setSelectedMessage);
      },
    );
  }

  void _setSelectedMessage(String message) {
    setState(() {
      messageController.value = messageController.value.copyWith(text: message);
    });
  }

  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          isKeyboardVisible = true;
        } else {
          isKeyboardVisible = false;
        }
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ShareWithClientPageState>(
    onInit: (store) {
      String clientMessage = '[Your message goes here]\n\nAccess your client portal here: \nhttps://dandylight.com/clientPortal/${profile!.uid}+${job!.documentId}';
      messageController.value = messageController.value.copyWith(text: job!.proposal!.shareMessage! != null && job!.proposal!.shareMessage!.isNotEmpty ? job!.proposal!.shareMessage : clientMessage);
      if(job!.proposal!.shareMessage == null || job!.proposal!.shareMessage!.isEmpty) {
        store.dispatch(SetClientShareMessageAction(store.state.shareWithClientPageState!, clientMessage));
      } else {
        store.dispatch(SetClientShareMessageAction(store.state.shareWithClientPageState!, job!.proposal!.shareMessage!));
      }
    },
  converter: (Store<AppState> store) => ShareWithClientPageState.fromStore(store),
  builder: (BuildContext context, ShareWithClientPageState pageState) =>
  Container(
        height: 516.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          color: Color(ColorConstants.getPrimaryWhite()),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 32),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Share with ${client!.firstName}',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'SMS/Email message',
              ),
            ),
            Container(
              height: 264,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
              padding: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ShareWithClientTextField(
                      messageController,
                      '',
                      TextInputType.multiline,
                      264.0,
                      pageState.onShareMessageChanged,
                      'noError',
                      TextInputAction.newline,
                      _messageFocusNode,
                      onAction,
                      TextCapitalization.sentences,
                      null,
                      true,
                      true,
                      true,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (client!.phone != null && client!.phone!.isNotEmpty) {
                      IntentLauncherUtil.sendSMSWithBody(client!.phone!, pageState.clientShareMessage);
                    } else {
                      DandyToastUtil.showErrorToast('A phone number has not been saved for ${client!.firstName}');
                    }
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 54.0,
                        width: 54.0,
                        child: Image.asset('assets/images/icons/chat_circle.png', color: Color(ColorConstants.getPeachDark())),
                      ),
                      TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'SMS'
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (client!.email != null && client!.email!.isNotEmpty) {
                      IntentLauncherUtil.sendEmail(client!.email!, emailTitle!, pageState.clientShareMessage);
                    } else {
                      DandyToastUtil.showErrorToast('An email has not been saved for ${client!.firstName}');
                    }
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 54.0,
                        width: 54.0,
                        child: Image.asset('assets/images/icons/email_circle.png', color: Color(ColorConstants.getPeachDark())),
                      ),
                      TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Email'
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: pageState.clientShareMessage));
                    DandyToastUtil.showToast('Copied to Clipboard!', Color(ColorConstants.getPeachDark()));
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 54.0,
                        width: 54.0,
                        child: Image.asset('assets/images/icons/link.png', color: Color(ColorConstants.getPeachDark())),
                      ),
                      TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Copy'
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Share.share(pageState.clientShareMessage);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 52.0,
                        width: 52.0,
                        margin: const EdgeInsets.only(bottom: 2),
                        child: Image.asset('assets/images/icons/other.png', color: Color(ColorConstants.getPeachDark())),
                      ),
                      TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Other'
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
  );

  void onAction(){
    _messageFocusNode.unfocus();
  }
}