import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/edit_branding_page/EditBrandingPageState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/DandyLightTextFieldOld.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputDoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class ShowImageUploadProgressDialog extends StatefulWidget {

  @override
  _ShowImageUploadProgressDialog createState() {
    return _ShowImageUploadProgressDialog();
  }
}

class _ShowImageUploadProgressDialog extends State<ShowImageUploadProgressDialog> with AutomaticKeepAliveClientMixin {
  OverlayEntry? overlayEntry;
  final FocusNode taxRateFocusNode = FocusNode();
  var taxRateTextController = TextEditingController();
  String enteredRate = '';
  late StreamSubscription<bool> keyboardSubscription;
  bool alreadyPopped = false;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          showOverlay(context);
        } else {
          removeOverlay();
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
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, EditBrandingPageState>(
      onDidChange: (previous, current) {
        if(!(current.uploadInProgress ?? false) && !alreadyPopped) {
          Navigator.of(context).pop();
          setState(() {
            alreadyPopped = true;
          });
        }
      },
      converter: (store) => EditBrandingPageState.fromStore(store),
      builder: (BuildContext context, EditBrandingPageState pageState) =>
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 264,
                height: 96,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Uploading image',
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Expanded(
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: pageState.uploadProgress,
                                borderRadius: BorderRadius.circular(8),
                                color: Color(ColorConstants.getPrimaryGreyDark()),
                                backgroundColor: Color(ColorConstants.getPrimaryGreyMedium()),
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: '${pageState.uploadProgress.toString()}%',
                              isBold: true,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }

  String getProgressString(String progressValue) {
    String result = '0';
    double progress = double.parse(progressValue)*100;
    result = progress.toStringAsFixed(0);
    return result;
  }

  void saveEnteredRateLocal(String rate) {
    enteredRate = rate;
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
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

  @override
  bool get wantKeepAlive => true;
}
