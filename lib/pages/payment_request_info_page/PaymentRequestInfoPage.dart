import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../widgets/TextDandyLight.dart';
import '../new_session_type_page/DandyLightTextField.dart';
import 'DandyLightSettingsTextField.dart';
import 'PaymentRequestInfoPageActions.dart';


class PaymentRequestInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaymentRequestInfoPageState();
  }
}

class _PaymentRequestInfoPageState extends State<PaymentRequestInfoPage> with TickerProviderStateMixin {
  final zellePhoneEmailTextController = TextEditingController();
  final zelleFullNameTextController = TextEditingController();
  final venmoLinkTextController = TextEditingController();
  final cashAppLinkTextController = TextEditingController();
  final applePayLinkTextController = TextEditingController();
  final otherTextController = TextEditingController();
  final wireTextController = TextEditingController();
  final cashTextController = TextEditingController();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PaymentRequestInfoPageState>(
        onInit: (store) async {
          await store.dispatch(LoadPaymentSettingsFromProfile(store.state.paymentRequestInfoPageState));
          if(store.state.paymentRequestInfoPageState!.zellePhoneEmail?.isNotEmpty == true) {
            zellePhoneEmailTextController.text = store.state.paymentRequestInfoPageState!.zellePhoneEmail!;
          }
          if(store.state.paymentRequestInfoPageState!.zelleFullName?.isNotEmpty == true) {
            zelleFullNameTextController.text = store.state.paymentRequestInfoPageState!.zelleFullName!;
          }
          if(store.state.paymentRequestInfoPageState!.venmoLink?.isNotEmpty == true) {
            venmoLinkTextController.text = store.state.paymentRequestInfoPageState!.venmoLink!;
          }
          if(store.state.paymentRequestInfoPageState!.cashAppLink?.isNotEmpty == true) {
            cashAppLinkTextController.text = store.state.paymentRequestInfoPageState!.cashAppLink!;
          }
          if(store.state.paymentRequestInfoPageState!.applePayPhone?.isNotEmpty == true) {
            applePayLinkTextController.text = store.state.paymentRequestInfoPageState!.applePayPhone!;
          }
          if(store.state.paymentRequestInfoPageState!.otherMessage?.isNotEmpty == true) {
            otherTextController.text = store.state.paymentRequestInfoPageState!.otherMessage!;
          }
          if(store.state.paymentRequestInfoPageState!.wireMessage?.isNotEmpty == true) {
            wireTextController.text = store.state.paymentRequestInfoPageState!.wireMessage!;
          }
          if(store.state.paymentRequestInfoPageState!.cashMessage?.isNotEmpty == true) {
            cashTextController.text = store.state.paymentRequestInfoPageState!.cashMessage!;
          } else {
            cashTextController.text = '(Example message) Please send me a message to coordinate a cash payment.  Thank you!';
          }
        },
    onDidChange: (previous, current) {
      if(previous!.zellePhoneEmail!.isEmpty && current.zellePhoneEmail?.isNotEmpty == true) {
        zellePhoneEmailTextController.text = current.zellePhoneEmail!;
        zellePhoneEmailTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: zellePhoneEmailTextController.text.length,
          ),
        );
      }
      if(previous.zelleFullName!.isEmpty && current.zelleFullName?.isNotEmpty == true) {
        zelleFullNameTextController.text = current.zelleFullName!;
        zelleFullNameTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: zelleFullNameTextController.text.length,
          ),
        );
      }
      if(previous.venmoLink!.isEmpty && current.venmoLink?.isNotEmpty == true) {
        venmoLinkTextController.text = current.venmoLink!;
        venmoLinkTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: venmoLinkTextController.text.length,
          ),
        );
      }
      if(previous.cashAppLink!.isEmpty && current.cashAppLink?.isNotEmpty == true) {
        cashAppLinkTextController.text = current.cashAppLink!;
        cashAppLinkTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: cashAppLinkTextController.text.length,
          ),
        );
      }
      if(previous.applePayPhone!.isEmpty && current.applePayPhone?.isNotEmpty == true) {
        applePayLinkTextController.text = current.applePayPhone!;
        applePayLinkTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: applePayLinkTextController.text.length,
          ),
        );
      }
      if(previous.otherMessage!.isEmpty && current.otherMessage?.isNotEmpty == true) {
        otherTextController.text = current.otherMessage!;
        otherTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: otherTextController.text.length,
          ),
        );
      }
      if(previous.wireMessage!.isEmpty && current.wireMessage?.isNotEmpty == true) {
        wireTextController.text = current.wireMessage!;
        wireTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: wireTextController.text.length,
          ),
        );
      }
    },
        converter: (Store<AppState> store) => PaymentRequestInfoPageState.fromStore(store),
        builder: (BuildContext context, PaymentRequestInfoPageState pageState) =>
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      iconTheme: IconThemeData(
                        color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                      ),
                      backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0.0,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                          text: "Payment Link Info",
                        color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0, bottom: 16.0),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Please select the payment services below that you use.  The provided payment information will be used to add a payment link to your DandyLight invoices.',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Venmo',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    Device.get().isIos?
                                    CupertinoSwitch(
                                      trackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      onChanged: (enabled) {
                                        pageState.onVenmoSelected!(enabled);
                                      },
                                      value: pageState.venmoEnabled!,
                                    ) : Switch(
                                      activeTrackColor: Color(ColorConstants.getBlueLight()),
                                      inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      onChanged: (enabled) {
                                        pageState.onVenmoSelected!(enabled);
                                      },
                                      value: pageState.venmoEnabled!,
                                    )
                                  ],
                                ),
                                pageState.venmoEnabled! ? Container(
                                  margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Please provide the shareable payment link for your Venmo account.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ) : SizedBox(),
                                pageState.venmoEnabled! ? DandyLightSettingsTextField(
                                  controller: venmoLinkTextController,
                                  hintText: 'Payment link',
                                  inputType: TextInputType.url,
                                  focusNode: null,
                                  onFocusAction: pageState.onVenmoInputDone,
                                  height: 66.0,
                                  onTextInputChanged: pageState.onVenmoTextChanged,
                                  keyboardAction: TextInputAction.done,
                                  capitalization: TextCapitalization.none,
                                ) : SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Wire Transfer/E-Transfer',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    Device.get().isIos?
                                    CupertinoSwitch(
                                      trackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      onChanged: (enabled) {
                                        pageState.onWireSelected!(enabled);
                                      },
                                      value: pageState.wireEnabled!,
                                    ) : Switch(
                                      activeTrackColor: Color(ColorConstants.getBlueLight()),
                                      inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      onChanged: (enabled) {
                                        pageState.onWireSelected!(enabled);
                                      },
                                      value: pageState.wireEnabled!,
                                    )
                                  ],
                                ),
                                pageState.wireEnabled! ? Container(
                                  margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Please provide the Wire Transfer/E-Transfer details your client will need to perform a transfer. This information will be shown to your client on the invoice page in your client portal.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ) : SizedBox(),
                                pageState.wireEnabled! ? DandyLightSettingsTextField(
                                  controller: wireTextController,
                                  hintText: 'Details',
                                  inputType: TextInputType.text,
                                  focusNode: null,
                                  maxLines: 50,
                                  onFocusAction: pageState.onWireInputDone,
                                  height: 132.0,
                                  onTextInputChanged: pageState.onWireMessageChanged,
                                  keyboardAction: TextInputAction.done,
                                  capitalization: TextCapitalization.sentences,
                                ) : SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Cash',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    Device.get().isIos?
                                    CupertinoSwitch(
                                      trackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      onChanged: (enabled) {
                                        pageState.onCashSelected!(enabled);
                                      },
                                      value: pageState.cashEnabled!,
                                    ) : Switch(
                                      activeTrackColor: Color(ColorConstants.getBlueLight()),
                                      inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      onChanged: (enabled) {
                                        pageState.onCashSelected!(enabled);
                                      },
                                      value: pageState.cashEnabled!,
                                    )
                                  ],
                                ),
                                pageState.cashEnabled! ? Container(
                                  margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'By enabling Cash, your clients will be informed on their invoice that cash is an option for payment. Please add a message below for your client to see when they select "Pay with cash" from their invoice.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ) : SizedBox(),
                                pageState.cashEnabled! ? DandyLightSettingsTextField(
                                  controller: cashTextController,
                                  hintText: 'Message',
                                  inputType: TextInputType.text,
                                  focusNode: null,
                                  maxLines: 50,
                                  onFocusAction: pageState.onCashInputDone,
                                  height: 132.0,
                                  onTextInputChanged: pageState.onCashMessageChanged,
                                  keyboardAction: TextInputAction.done,
                                  capitalization: TextCapitalization.sentences,
                                ) : SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Zelle',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    Device.get().isIos?
                                    CupertinoSwitch(
                                      trackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      onChanged: (enabled) {
                                        pageState.onZelleSelected!(enabled);
                                      },
                                      value: pageState.zelleEnabled!,
                                    ) : Switch(
                                      activeTrackColor: Color(ColorConstants.getBlueLight()),
                                      inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      onChanged: (enabled) {
                                        pageState.onZelleSelected!(enabled);
                                      },
                                      value: pageState.zelleEnabled!,
                                    )
                                  ],
                                ),
                                pageState.zelleEnabled! ? Container(
                                  margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Please provide the mobile number or email associated with your Zelle account.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ) : SizedBox(),
                                pageState.zelleEnabled! ? DandyLightSettingsTextField(
                                  controller: zellePhoneEmailTextController,
                                  hintText: 'Phone or Email',
                                  inputType: TextInputType.emailAddress,
                                  focusNode: null,
                                  onFocusAction: pageState.onZellePhoneEmailInputDone,
                                  height: 66.0,
                                  onTextInputChanged: pageState.onZelleTextPhoneEmailChanged,
                                  keyboardAction: TextInputAction.done,
                                  capitalization: TextCapitalization.none,
                                ) : SizedBox(),
                                pageState.zelleEnabled! ? Container(
                                  margin: EdgeInsets.only(top: 24.0, bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Please provide the full name associated with your Zelle account.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ) : SizedBox(),
                                pageState.zelleEnabled! ? DandyLightSettingsTextField(
                                  controller: zelleFullNameTextController,
                                  hintText: 'Full name',
                                  inputType: TextInputType.text,
                                  focusNode: null,
                                  onFocusAction: pageState.onZelleFullNameInputDone,
                                  height: 66.0,
                                  onTextInputChanged: pageState.onZelleTextFullNameChanged,
                                  keyboardAction: TextInputAction.done,
                                  capitalization: TextCapitalization.words,
                                ) : SizedBox(),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Cash App',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    Device.get().isIos?
                                    CupertinoSwitch(
                                      trackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      onChanged: (enabled) {
                                        pageState.onCashAppSelected!(enabled);
                                      },
                                      value: pageState.cashAppEnabled!,
                                    ) : Switch(
                                      activeTrackColor: Color(ColorConstants.getBlueLight()),
                                      inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      onChanged: (enabled) {
                                        pageState.onCashAppSelected!(enabled);
                                      },
                                      value: pageState.cashAppEnabled!,
                                    )
                                  ],
                                ),
                                pageState.cashAppEnabled! ? Container(
                                  margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Please provide the shareable payment link for your Cash App account.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ) : SizedBox(),
                                pageState.cashAppEnabled! ? DandyLightSettingsTextField(
                                  controller: cashAppLinkTextController,
                                  hintText: 'Payment link',
                                  inputType: TextInputType.url,
                                  focusNode: null,
                                  onFocusAction: pageState.onCashAppInputDone,
                                  height: 66.0,
                                  onTextInputChanged: pageState.onCashAppTextChanged,
                                  keyboardAction: TextInputAction.done,
                                  capitalization: TextCapitalization.none,
                                ) : SizedBox(),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                          //   padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                          //   decoration: BoxDecoration(
                          //     color: Color(ColorConstants.getPrimaryWhite()),
                          //     borderRadius: BorderRadius.circular(16.0),
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           TextDandyLight(
                          //             type: TextDandyLight.MEDIUM_TEXT,
                          //             text: 'Apple Pay',
                          //             textAlign: TextAlign.center,
                          //             color: Color(ColorConstants.getPrimaryBlack()),
                          //           ),
                          //           Device.get().isIos?
                          //           CupertinoSwitch(
                          //             trackColor: Color(ColorConstants.getBlueLight()),
                          //             activeColor: Color(ColorConstants.getBlueDark()),
                          //             onChanged: (enabled) {
                          //               pageState.onApplePaySelected(enabled);
                          //             },
                          //             value: pageState.applePayEnabled,
                          //           ) : Switch(
                          //             activeTrackColor: Color(ColorConstants.getBlueLight()),
                          //             inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                          //             activeColor: Color(ColorConstants.getBlueDark()),
                          //             onChanged: (enabled) {
                          //               pageState.onApplePaySelected(enabled);
                          //             },
                          //             value: pageState.applePayEnabled,
                          //           )
                          //         ],
                          //       ),
                          //       pageState.applePayEnabled ? Container(
                          //         margin: EdgeInsets.only(top: 16.0, bottom: 0.0),
                          //         child: TextDandyLight(
                          //           type: TextDandyLight.SMALL_TEXT,
                          //           text: 'Please provide the phone number associated with your Apple Pay',
                          //           textAlign: TextAlign.start,
                          //           color: Color(ColorConstants.getPrimaryBlack()),
                          //         ),
                          //       ) : SizedBox(),
                          //       pageState.applePayEnabled ? DandyLightSettingsTextField(
                          //         controller: applePayLinkTextController,
                          //         hintText: 'Phone number',
                          //         inputType: TextInputType.text,
                          //         focusNode: null,
                          //         onFocusAction: pageState.onApplePayInputDone,
                          //         height: 66.0,
                          //         onTextInputChanged: pageState.onApplePayTextChanged,
                          //         keyboardAction: TextInputAction.done,
                          //         capitalization: TextCapitalization.none,
                          //       ) : SizedBox(),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 128.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Other',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    Device.get().isIos?
                                    CupertinoSwitch(
                                      trackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      onChanged: (enabled) {
                                        pageState.onOtherSelected!(enabled);
                                      },
                                      value: pageState.otherEnabled!,
                                    ) : Switch(
                                      activeTrackColor: Color(ColorConstants.getBlueLight()),
                                      inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                      activeColor: Color(ColorConstants.getBlueDark()),
                                      onChanged: (enabled) {
                                        pageState.onOtherSelected!(enabled);
                                      },
                                      value: pageState.otherEnabled!,
                                    )
                                  ],
                                ),
                                pageState.otherEnabled! ? Container(
                                  margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Please provide the details of this payment method for your clients to see when they receive their invoice.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ) : SizedBox(),
                                pageState.otherEnabled! ? DandyLightSettingsTextField(
                                  controller: otherTextController,
                                  hintText: 'Message',
                                  inputType: TextInputType.text,
                                  focusNode: null,
                                  maxLines: 50,
                                  onFocusAction: pageState.onOtherInputDone,
                                  height: 132.0,
                                  onTextInputChanged: pageState.onOtherMessageChanged,
                                  keyboardAction: TextInputAction.done,
                                  capitalization: TextCapitalization.sentences,
                                ) : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
}
