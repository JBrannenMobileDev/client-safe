import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/ImageUtil.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';
import '../new_contact_pages/NewContactTextField.dart';
import 'ClientDetailsTextField.dart';

class LeadSourceSelectionWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LeadSourceSelectionWidget();
  }
}

class _LeadSourceSelectionWidget extends State<LeadSourceSelectionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
              height: KeyboardUtil.isVisible(context) ? MediaQuery.of(context).size.height-64 : 550,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                  color: Color(ColorConstants.getPrimaryWhite())),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 4.0, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Cancel',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              modalPageState.onSaveLeadSourceSelected();
                              Navigator.of(context).pop();
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Save',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 0, bottom: 32.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Select a lead source',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Container(
                    height: 232,
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: 8,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.8),
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
                                TextDandyLight(
                                  type: TextDandyLight.EXTRA_SMALL_TEXT,
                                  text: ImageUtil.getLeadSourceText(leadSourceIconsWhite.elementAt(index)),
                                  textAlign: TextAlign.center,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Container(
                    height: 82.0,
                    width: 275,
                    child: modalPageState.leadSource == 'assets/images/icons/email_icon_white.png'
                        ? ClientDetailsTextView(
                      customLeadController,
                      "Custom Name",
                      TextInputType.text,
                      66.0,
                      modalPageState.onCustomLeadSourceTextChanged,
                      NewContactPageState.NO_ERROR,
                      TextInputAction.done,
                      _customLeadFocusNode,
                      () {
                        _customLeadFocusNode.unfocus();
                      },
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

