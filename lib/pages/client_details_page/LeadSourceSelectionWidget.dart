import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../AppState.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/styles/Styles.dart';
import '../new_contact_pages/NewContactPageState.dart';
import '../new_contact_pages/NewContactTextField.dart';

class LeadSourceSelectionWidget extends StatelessWidget {
  final customLeadController = TextEditingController();
  final FocusNode _customLeadFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<String> leadSourceIconsWhite = ImageUtil.leadSourceIconsWhite;
    List<String> leadSourceIconsPeach = ImageUtil.leadSourceIconsPeach;
    return StoreConnector<AppState, ClientDetailsPageState>(
      onInit: (store) {
        customLeadController.value = customLeadController.value.copyWith(text:store.state.clientDetailsPageState.customLeadSourceName);
      },
      onWillChange: (statePrevious, stateNew) {
        customLeadController.value = customLeadController.value.copyWith(text:stateNew.customLeadSourceName);
      },
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState modalPageState) =>
          Container(
        height: 500,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            color: Color(ColorConstants.getPrimaryWhite())),
        child: Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          modalPageState.onSaveLeadSourceSelected();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Save',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 32.0),
                child: Text(
                  'Select a lead source',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: 8,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 0.8),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        modalPageState.onLeadSourceSelected(
                            leadSourceIconsWhite.elementAt(index));
                      },
                      child: Column(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              modalPageState.leadSource != null && getIconPosition(modalPageState, leadSourceIconsWhite) == index
                                  ? new Container(
                                      margin: EdgeInsets.only(bottom: 8.0),
                                      height: 46.0,
                                      width: 46.0,
                                      decoration: new BoxDecoration(
                                        color: Color(
                                            ColorConstants.getBlueLight()),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 54.0,
                                      width: 46.0,
                                    ),
                              Container(
                                margin: EdgeInsets.only(bottom: 8.0),
                                height: 36.0,
                                width: 36.0,
                                child: Image.asset(
                                  leadSourceIconsPeach.elementAt(index),
                                  color: Color(
                                      modalPageState.leadSource != null &&
                                              getIconPosition(modalPageState,
                                                      leadSourceIconsWhite) ==
                                                  index
                                          ? ColorConstants.getPrimaryWhite()
                                          : ColorConstants.getPeachDark()),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ImageUtil.getLeadSourceText(
                                leadSourceIconsWhite.elementAt(index)),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              Container(
                height: 66.0,
                width: 275,
                child: modalPageState.leadSource ==
                        'assets/images/icons/email_icon_white.png'
                    ? NewContactTextField(
                        customLeadController,
                        "Custom Name",
                        TextInputType.text,
                        66.0,
                        modalPageState.onCustomLeadSourceTextChanged,
                        NewContactPageState.NO_ERROR,
                        TextInputAction.done,
                        _customLeadFocusNode,
                        onAction,
                        TextCapitalization.words,
                        null,
                        true,
                        ColorConstants.getPrimaryColor(),
                )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLeadSourceName(ClientDetailsPageState pageState) {
    return (pageState.client.customLeadSourceName != null && pageState.client.customLeadSourceName.isNotEmpty ? pageState.client.customLeadSourceName : ImageUtil.getLeadSourceText(pageState.client.leadSource));

  }

  void onAction(){
    _customLeadFocusNode.unfocus();
  }

  int getIconPosition(ClientDetailsPageState pageState, List<String> leadSourceIconsWhite) {
    return leadSourceIconsWhite.indexOf(pageState.leadSource);
  }
}