import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/InputDoneView.dart';
import 'NewContactTextField.dart';

class PhoneEmailInstagram extends StatefulWidget {
  @override
  _PhoneEmailInstagramState createState() {
    return _PhoneEmailInstagramState();
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

      int selectionIndex = newValue.selection.end;
      String resultNum = "";
      String numsOnly = newValue.text.replaceAll(RegExp('[^0-9]+'), "");

      if(numsOnly.length == 10){
        resultNum = "(" + numsOnly.substring(0, 3) + ") " + numsOnly.substring(3, 6) + "-" + numsOnly.substring(6, numsOnly.length);
        selectionIndex = selectionIndex + 4;
      }else if(numsOnly.length == 11){
        resultNum = "+" + numsOnly.substring(0,1) + "(" + numsOnly.substring(1, 4) + ") " + numsOnly.substring(4, 7) + "-" + numsOnly.substring(7, numsOnly.length);
        selectionIndex = selectionIndex + 5;
      }else{
        resultNum = numsOnly;
      }
    return new TextEditingValue(
      text: resultNum,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class _PhoneEmailInstagramState extends State<PhoneEmailInstagram>
    with AutomaticKeepAliveClientMixin {
  final phoneTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final instagramUrlTextController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _instagramFocus = FocusNode();
  final _mobileFormatter = NumberTextInputFormatter();
  OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewContactPageState>(
        onInit: (store) {
          phoneTextController.text = store.state.newContactPageState.newContactPhone;
          emailTextController.text = store.state.newContactPageState.newContactEmail;
          instagramUrlTextController.text = store.state.newContactPageState.newContactInstagramUrl;

          KeyboardVisibilityNotification().addNewListener(
              onShow: () {
                showOverlay(context);
              },
              onHide: () {
                removeOverlay();
              }
          );
        },
        converter: (store) => NewContactPageState.fromStore(store),
        builder: (BuildContext context, NewContactPageState pageState) =>
            Container(
          margin: EdgeInsets.only(left: 26.0, right: 26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NewContactTextField(
                  phoneTextController,
                  "Phone",
                  TextInputType.phone,
                  60.0,
                  pageState.onPhoneTextChanged,
                  NewContactPageState.ERROR_PHONE_INVALID,
                  TextInputAction.next,
                  _phoneFocus,
                  onPhoneAction,
                  TextCapitalization.none,
                  <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    _mobileFormatter,
                  ],
                  true,
                ColorConstants.getBlueLight(),
              ),
              NewContactTextField(
                  emailTextController,
                  "Email",
                  TextInputType.emailAddress,
                  60.0,
                  pageState.onEmailTextChanged,
                  NewContactPageState.ERROR_EMAIL_NAME_INVALID,
                  TextInputAction.next,
                  _emailFocus,
                  onEmailAction,
                  TextCapitalization.none,
                  null,
                  true,
                ColorConstants.getBlueLight(),
              ),
              NewContactTextField(
                  instagramUrlTextController,
                  "Instagram URL",
                  TextInputType.url,
                  60.0,
                  pageState.onInstagramUrlChanged,
                  NewContactPageState.ERROR_INSTAGRAM_URL_INVALID,
                  TextInputAction.done,
                  _instagramFocus,
                  onInstagramAction,
                  TextCapitalization.none,
                  null,
                  true,
                ColorConstants.getBlueLight(),
              ),
            ],
          ),
        ),
      );

  void onPhoneAction(){
    _phoneFocus.unfocus();
    FocusScope.of(context).requestFocus(_emailFocus);
  }

  void onEmailAction(){
    _emailFocus.unfocus();
    FocusScope.of(context).requestFocus(_instagramFocus);
  }

  void onInstagramAction(){
    _emailFocus.unfocus();
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

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
