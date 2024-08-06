import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';
import '../../widgets/TextFieldSimple.dart';
import 'BookingPageActions.dart';
import 'BookingPageState.dart';
import 'SelectSessionTypeBottomSheet.dart';

class NewOfferingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewOfferingPage();
  }
}

class _NewOfferingPage extends State<NewOfferingPage>  with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final descriptionController = TextEditingController();
  final descriptionFocusNode = FocusNode();

  bool descriptionError = false;
  bool sessionTypeError = false;

  bool isTyping = false;

  bool bookByInquiryInfoVisible = false;
  bool instantBookingInfoVisible = false;
  bool requireDepositInfoVisible = false;

  AnimationController? controllerInquiry;
  AnimationController? controllerInstant;
  AnimationController? controllerDeposit;

  Tween<Offset>? offsetUpTween;
  Tween<Offset>? offsetDownTween;

  void setIsTyping(bool hasFocus) {
    isTyping = hasFocus;
  }

  @override
  initState() {
    super.initState();
    offsetDownTween = Tween<Offset>(
      begin: const Offset(0.0, -0.15),
      end: Offset.zero,
    );
    controllerInquiry = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this
    );
    controllerInstant = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this
    );
    controllerDeposit = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this
    );

    descriptionFocusNode.addListener(() {
      setIsTyping(descriptionFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    descriptionFocusNode.removeListener((){});
  }

  Animation<Offset> get offsetAnimationDownInquiry => offsetDownTween!.animate(
    CurvedAnimation(
      parent: controllerInquiry!,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.ease,
      ),
    ),
  );

  Animation<Offset> get offsetAnimationDownInstant => offsetDownTween!.animate(
    CurvedAnimation(
      parent: controllerInstant!,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.ease,
      ),
    ),
  );

  Animation<Offset> get offsetAnimationDownDeposit => offsetDownTween!.animate(
    CurvedAnimation(
      parent: controllerDeposit!,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.ease,
      ),
    ),
  );

  void _showSessionSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectSessionTypeBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookingPageState>(
      onInit: (store) {
        store.dispatch(InitializeStateAction(store.state.bookingPageState));
      },
      converter: (store) => BookingPageState.fromStore(store),
      builder: (BuildContext context, BookingPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                      surfaceTintColor: Colors.transparent,
                      centerTitle: true,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'New Offering',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close, color: Color(ColorConstants.getPrimaryBlack())),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 0, top: 16),
                            child: buildOptionWidget(
                                'SESSION TYPE*',
                                null,
                                pageState.selectedSessionType != null ? (pageState.selectedSessionType?.title ?? 'N/A') : 'Select session type',
                                    (){
                                  _showSessionSelectionBottomSheet(context);
                                },
                                sessionTypeError
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 32, right: 24, top: 8, bottom: 4),
                            child: TextDandyLight(
                              type: TextDandyLight.EXTRA_SMALL_TEXT,
                              text: 'DESCRIPTION (For booking web page)*',
                              color: Color(ColorConstants.getPrimaryGreyDark()),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                            child: TextFieldSimple(
                              controller: descriptionController,
                              hintText: 'Please provide a detailed description for this offering, including the services provided. For example, include an introduction, a list of what\'s included, the number of edits, and the method of photo delivery.',
                              inputType: TextInputType.name,
                              focusNode: descriptionFocusNode,
                              hasError: descriptionError,
                              height: 164,
                              onFocusAction: (){
                                FocusScope.of(context).unfocus();
                              },
                              onTextInputChanged: pageState.onOfferingDescriptionChanged!,
                              keyboardAction: TextInputAction.next,
                              capitalization: TextCapitalization.words,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16, bottom: 8),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Booking Settings',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Container(
                            height: 48.0,
                            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Book by inquiry',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          bookByInquiryInfoVisible = !bookByInquiryInfoVisible;
                                        });
                                        if(bookByInquiryInfoVisible) {
                                          controllerInquiry!.forward();
                                        } else {
                                          controllerInquiry!.reverse();
                                        }
                                      },
                                      child: Icon(Icons.info, color: Color(bookByInquiryInfoVisible ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium())),
                                    )
                                  ],
                                ),
                                Device.get().isIos?
                                CupertinoSwitch(
                                  trackColor: Color(ColorConstants.getBlueLight()),
                                  activeColor: Color(ColorConstants.getBlueDark()),
                                  thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                  onChanged: (enabled) async {
                                    pageState.onInquiryChanged!(enabled);
                                  },
                                  value: pageState.bookByInquiry ?? false,
                                ) : Switch(
                                  activeTrackColor: Color(ColorConstants.getBlueLight()),
                                  inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                  activeColor: Color(ColorConstants.getBlueDark()),
                                  onChanged: (enabled) async {
                                    pageState.onInquiryChanged!(enabled);
                                  },
                                  value: pageState.bookByInquiry ?? false,
                                )
                              ],
                            ),
                          ),
                          bookByInquiryInfoVisible ? SlideTransition(
                            position: offsetAnimationDownInquiry,
                            child: Container(
                              margin: const EdgeInsets.only(left: 24, right: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Book by inquiry allows your potential clients to fill out their information and submit an inquiry for your services. ',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                          ) : const SizedBox(),
                          SizedBox(height: (bookByInquiryInfoVisible ? 16 : 0)),
                          Container(
                            height: 48.0,
                            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Instant Booking',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          instantBookingInfoVisible = !instantBookingInfoVisible;
                                        });
                                        if(instantBookingInfoVisible) {
                                          controllerInstant!.forward();
                                        } else {
                                          controllerInstant!.reverse();
                                        }
                                      },
                                      child: Icon(Icons.info, color: Color(instantBookingInfoVisible ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium())),
                                    )
                                  ],
                                ),
                                Device.get().isIos?
                                CupertinoSwitch(
                                  trackColor: Color(ColorConstants.getBlueLight()),
                                  activeColor: Color(ColorConstants.getBlueDark()),
                                  thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                  onChanged: (enabled) async {
                                    pageState.onInstantChanged!(enabled);
                                  },
                                  value: pageState.instantBooking ?? false,
                                ) : Switch(
                                  activeTrackColor: Color(ColorConstants.getBlueLight()),
                                  inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                  activeColor: Color(ColorConstants.getBlueDark()),
                                  onChanged: (enabled) async {
                                    pageState.onInstantChanged!(enabled);
                                  },
                                  value: pageState.instantBooking ?? false,
                                )
                              ],
                            ),
                          ),
                          instantBookingInfoVisible ? SlideTransition(
                            position: offsetAnimationDownInstant,
                            child: Container(
                              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Instant booking allows your potential clients to book a session instantly without submitting an inquiry, as long as you setup your availability and services that you offer.',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                          ) : const SizedBox(),
                          Container(
                            height: 48.0,
                            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2,),
                                        TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: 'Require Deposit',
                                          textAlign: TextAlign.center,
                                          color: (pageState.instantBooking ?? false) ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryGreyDark()),
                                        ),
                                        TextDandyLight(
                                          type: TextDandyLight.SMALL_TEXT,
                                          text: '(For instant booking)',
                                          textAlign: TextAlign.center,
                                          color: (pageState.instantBooking ?? false) ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryGreyDark()),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          requireDepositInfoVisible = !requireDepositInfoVisible;
                                        });
                                        if(requireDepositInfoVisible) {
                                          controllerDeposit!.forward();
                                        } else {
                                          controllerDeposit!.reverse();
                                        }
                                      },
                                      child: Icon(Icons.info, color: Color(requireDepositInfoVisible ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium())),
                                    )
                                  ],
                                ),
                                Device.get().isIos?
                                CupertinoSwitch(
                                  trackColor: Color(ColorConstants.getBlueLight()),
                                  activeColor: Color(ColorConstants.getBlueDark()),
                                  thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                  onChanged: (enabled) async {
                                    pageState.onRequiredChanged!(enabled);
                                  },
                                  value: pageState.requireDeposit ?? false,
                                ) : Switch(
                                  activeTrackColor: Color(ColorConstants.getBlueLight()),
                                  inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                  activeColor: Color(ColorConstants.getBlueDark()),
                                  onChanged: (enabled) async {
                                    pageState.onRequiredChanged!(enabled);
                                  },
                                  value: pageState.requireDeposit ?? false,
                                )
                              ],
                            ),
                          ),
                          requireDepositInfoVisible ? SlideTransition(
                            position: offsetAnimationDownDeposit,
                            child: Container(
                              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Would you like to require potential clients to pay a deposit as part of the instant booking process?',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
                !isTyping ? GestureDetector(
                  onTap: () {
                    // if(pageState.selectedSessionType != null && (pageState.selectedSessionType?.totalCost ?? 0) == 0) {
                    //   showSessionTypeErrorBottomSheet(context, pageState.selectedSessionType!);
                    // } else {
                    //   setState(() {
                    //     if((pageState.leadSource?.isEmpty ?? true) && pageState.selectedClient == null) {
                    //       leadSourceError = true;
                    //     } else {
                    //       leadSourceError = false;
                    //     }
                    //     if(pageState.selectedSessionType == null) {
                    //       sessionTypeError = true;
                    //     } else {
                    //       sessionTypeError = false;
                    //     }
                    //     if(pageState.selectedClient == null && (pageState.deviceContactFirstName?.isEmpty ?? true)) {
                    //       descriptionError = true;
                    //       clientError = true;
                    //     } else {
                    //       descriptionError = false;
                    //       clientError = false;
                    //     }
                    //   });
                    //   if(!clientError && !descriptionError && !leadSourceError && !sessionTypeError) {
                    //     pageState.onSavePressed!();
                    //     showSuccessAnimation();
                    //   } else {
                    //     if(clientError) DandyToastUtil.showErrorToast('Missing client info');
                    //     else if(descriptionError) DandyToastUtil.showErrorToast('Missing client first name');
                    //     else if(leadSourceError) DandyToastUtil.showErrorToast('Missing client lead source');
                    //     else if(sessionTypeError) DandyToastUtil.showErrorToast('Missing session type');
                    //   }
                    // }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width/2,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Color(ColorConstants.getPeachDark()),
                      boxShadow: ElevationToShadow[4],
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Save',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ) : const SizedBox(),
              ],
            ),
          ),
    );
  }

  Widget setupContainer() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 42, right: 42, bottom: 24, top: 16),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            textAlign: TextAlign.center,
            text: 'Lets get started by setting up your booking page!',
          ),
        ),
        GestureDetector(
          onTap: () {

          },
          child: Container(
            alignment: Alignment.center,
            height: 54,
            width: 232,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(ColorConstants.getPrimaryGreyDark())
            ),
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              textAlign: TextAlign.center,
              text: 'Setup Booking',
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        )
      ],
    );
  }

  Widget buildOptionWidget(String title, String? message, String buttonMessage, Function action, bool errorState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, top: 0),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: title,
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        message != null ? Container(
          margin: const EdgeInsets.only(left: 8, top: 0),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            text: message,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ) : const SizedBox(),
        GestureDetector(
          onTap: () {
            action();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 0, bottom: 16),
            alignment: Alignment.center,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: errorState ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyDark()),
                  width: errorState ? 2 : 0
              ),
              color: Color(ColorConstants.getPrimaryGreyDark()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: buttonMessage,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget infoContainer(BookingPageState pageState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 24,
          margin: const EdgeInsets.only(left: 8),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            textAlign: TextAlign.start,
            text: 'Booking Link',
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: pageState.bookingLink ?? ''));
            DandyToastUtil.showToast('Copied!', Color(ColorConstants.getPeachDark()));
          },
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: MediaQuery.of(context).size.width-68,
                child: TextDandyLight(
                  type: TextDandyLight.SMALL_TEXT,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  color: Color(ColorConstants.getPrimaryGreyDark()),
                  text: pageState.bookingLink,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: Icon(Icons.copy, color: Color(ColorConstants.getPrimaryGreyDark())),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 24),
          height: 54,
          width: 224,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: 'Update Availability',
            color: Color(ColorConstants.getPrimaryWhite()),
          ),
        )
      ],
    );
  }

  Widget divider() {
    return Container(
      height: 48,
      width: 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
      ),
    );
  }

  Widget dayItem(String dayName, int index, bool isAvailable) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              textAlign: TextAlign.start,
              text: dayName,
            ),
          ),
          isAvailable ? Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(ColorConstants.getPrimaryGreyDark()),
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }
}
