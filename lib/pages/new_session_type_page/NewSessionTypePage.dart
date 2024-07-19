import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_session_type_page/ChooseStagesBottomSheet.dart';
import 'package:dandylight/pages/new_session_type_page/NewSessionTypePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../models/SessionType.dart';
import '../../utils/TextFormatterUtil.dart';
import '../../utils/flutter_masked_text.dart';
import '../../widgets/TextDandyLight.dart';
import '../../widgets/TextFieldSimple.dart';
import 'CustomJobStageBottomSheet.dart';
import 'NewSessionTypeActions.dart';

class NewSessionTypePage extends StatefulWidget {
  final SessionType? sessionType;

  NewSessionTypePage(this.sessionType);

  @override
  _NewSessionTypePageState createState() {
    return _NewSessionTypePageState(sessionType);
  }
}

class _NewSessionTypePageState extends State<NewSessionTypePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final minController = TextEditingController();
  final hoursController = TextEditingController();
  var totalCostTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '.', thousandSeparator: ',');
  var depositTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '.', thousandSeparator: ',');
  var taxPercentController = MoneyMaskedTextController(rightSymbol: '%', decimalSeparator: '.', thousandSeparator: ',');
  final nameFocusNode = FocusNode();
  final hourFocusNode = FocusNode();
  final minFocusNode = FocusNode();
  final totalCostInputFocusNode = FocusNode();
  final depositInputFocusNode = FocusNode();
  final taxPercentFocusNode = FocusNode();
  final SessionType? sessionType;

  _NewSessionTypePageState(this.sessionType);

  void _showChooseStagesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return ChooseStagesBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewSessionTypePageState>(
      onInit: (store) {
        if(sessionType == null) {
          store.dispatch(ClearNewJobTypeStateAction(store.state.newSessionTypePageState));
        }else {
          store.dispatch(LoadExistingSessionTypeData(store.state.newSessionTypePageState, sessionType));
        }
        // totalCostTextController.updateValue(store.state.pricingProfilePageState!.flatRate!);
        // depositTextController.updateValue(store.state.pricingProfilePageState!.deposit!);
        // taxPercentController.updateValue(store.state.pricingProfilePageState!.taxPercent!);

        store.dispatch(LoadPricesPackagesAndRemindersAction(store.state.newSessionTypePageState));
      },
      converter: (store) => NewSessionTypePageState.fromStore(store),
      builder: (BuildContext context, NewSessionTypePageState pageState) =>
        WillPopScope(
          onWillPop: () async {
            final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('All unsaved information entered will be lost.'),
                  actions: <Widget>[
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                )
            );
            return shouldPop!;
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                        pinned: true,
                        centerTitle: true,
                        surfaceTintColor: Colors.transparent,
                        title: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: pageState.shouldClear! ? "New Session Type" : "Edit Session Type",
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                        systemOverlayStyle: SystemUiOverlayStyle.dark,
                        leading: GestureDetector(
                          child: const Icon( Icons.close, color: Colors.black),
                          onTap: () {
                            Navigator.pop(context);
                          } ,
                        ) ,
                        actions: [
                          GestureDetector(
                            onTap: () {
                              _ackAlert(context, pageState);
                            },
                            child: Container(
                              height: 24.0,
                              margin: const EdgeInsets.only(right: 8),
                              child: Image.asset(
                                'assets/images/icons/trash_can.png', color: Color(ColorConstants.getPeachDark()),),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save, size: 32),
                            tooltip: 'Save',
                            color: Color(ColorConstants.getBlueDark()),
                            onPressed: () {
                              showSuccessAnimation();
                              pageState.onSavePressed!();
                            },
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Session Name',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            TextFieldSimple(
                              controller: nameController,
                              hintText: 'Name',
                              inputType: TextInputType.text,
                              focusNode: nameFocusNode,
                              onFocusAction: (){
                                FocusScope.of(context).requestFocus(hourFocusNode);
                              },
                              labelText: 'Name',
                              onTextInputChanged: pageState.onTitleChanged!,
                              keyboardAction: TextInputAction.next,
                              capitalization: TextCapitalization.words,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Session Duration',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width-36)/2,
                                  child: TextFieldSimple(
                                    controller: hoursController,
                                    hintText: '0',
                                    inputType: TextInputType.number,
                                    focusNode: hourFocusNode,
                                    onFocusAction: (){
                                      FocusScope.of(context).requestFocus(minFocusNode);
                                    },
                                    labelText: 'Hours',
                                    onTextInputChanged: pageState.onHoursChanged!,
                                    keyboardAction: TextInputAction.next,
                                  ),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width-36)/2,
                                  child: TextFieldSimple(
                                    controller: minController,
                                    hintText: '0',
                                    inputType: TextInputType.number,
                                    focusNode: minFocusNode,
                                    onFocusAction: null,
                                    labelText: 'Minutes',
                                    onTextInputChanged: pageState.onMinutesChanged!,
                                    keyboardAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Session Cost',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width-36)/2,
                                  child: TextFieldSimple(
                                    controller: totalCostTextController,
                                    inputType: TextInputType.number,
                                    focusNode: totalCostInputFocusNode,
                                    onFocusAction: (){
                                      FocusScope.of(context).requestFocus(minFocusNode);
                                    },
                                    labelText: 'Total Cost',
                                    onTextInputChanged: pageState.onTotalCostChanged!,
                                    keyboardAction: TextInputAction.next,
                                  ),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width-36)/2,
                                  child: TextFieldSimple(
                                    controller: depositTextController,
                                    inputType: TextInputType.number,
                                    focusNode: depositInputFocusNode,
                                    onFocusAction: null,
                                    labelText: 'Deposit',
                                    onTextInputChanged: pageState.onDepositChanged!,
                                    keyboardAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width-36)/2,
                                  child: TextFieldSimple(
                                    controller: taxPercentController,
                                    inputType: TextInputType.number,
                                    focusNode: taxPercentFocusNode,
                                    onFocusAction: (){
                                      FocusScope.of(context).requestFocus(minFocusNode);
                                    },
                                    labelText: 'Tax %',
                                    onTextInputChanged: pageState.onTaxPercentChanged!,
                                    keyboardAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                TextDandyLight(
                                  color: Color(taxPercentController.text.isNotEmpty ? ColorConstants.getPrimaryBlack() : ColorConstants.getBlueLight()),
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: '=',
                                ),
                                const SizedBox(width: 16),
                                TextDandyLight(
                                  color: Color(taxPercentController.text.isNotEmpty ? ColorConstants.getPrimaryBlack() : ColorConstants.getBlueLight()),
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: TextFormatterUtil.formatDecimalCurrency(pageState.taxAmount ?? 0.0),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Job Stages',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 8),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Please choose the stages you wish to track for this session type.',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showChooseStagesBottomSheet(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                alignment: Alignment.center,
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                                child: TextDandyLight(
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: (pageState.selectedJobStages?.isEmpty ?? true) ? 'Choose Stages' : '${pageState.selectedJobStages?.length ?? 0} Stages',
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 24),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Session Reminders',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 8),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Please choose your personal reminders for this session type.',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                alignment: Alignment.center,
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                                child: TextDandyLight(
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: 'Choose Reminders',
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                            const SizedBox(height: 164),
                            // ReminderSelectionWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      pageState.onSavePressed!();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/2,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: Color(ColorConstants.getBlueDark()),
                        boxShadow: ElevationToShadow[4],
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Save',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Future<void> _ackAlert(BuildContext context, NewSessionTypePageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This session type will be permanently deleted.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteJobTypeSelected!();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This session type will be permanently deleted.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteJobTypeSelected!();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
