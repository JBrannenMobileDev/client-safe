import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/Client.dart';
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

  List<String> _chipLabels = Client.getLeadSources();

  bool isSelected(int index, ClientDetailsPageState pageState) {
    return _chipLabels.elementAt(index) == pageState.leadSource;
  }

  @override
  Widget build(BuildContext context) {
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
                              color: Color(ColorConstants.getPrimaryBlack()),
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
                              color: Color(ColorConstants.getPrimaryBlack()),
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
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    height: 232,
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Container(
                      child: Wrap(
                        spacing: 8.0,
                        children: List<Widget>.generate(
                          _chipLabels.length,
                              (int index) {
                            return Container(
                                  child: ChoiceChip(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextDandyLight(
                                          type: TextDandyLight.SMALL_TEXT,
                                          text: _chipLabels.elementAt(index),
                                          textAlign: TextAlign.start,
                                          color: Color(ColorConstants.getPrimaryBlack()),
                                        ),
                                        isSelected(index, modalPageState)
                                            ? Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                          child: Icon(Icons.close, size: 20,),
                                        )
                                            : SizedBox(),
                                      ],
                                    ),
                                    backgroundColor:
                                    Color(ColorConstants.primary_bg_grey),
                                    selectedColor: Color(ColorConstants.getBlueLight()),
                                    selected: modalPageState.leadSource == _chipLabels.elementAt(index),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          modalPageState.onLeadSourceSelected(_chipLabels.elementAt(index));
                                        }
                                      });
                                    },
                                  ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  Container(
                    height: 82.0,
                    width: 275,
                    child: modalPageState.leadSource == Client.LEAD_SOURCE_OTHER
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

  void onAction(){
    _customLeadFocusNode.unfocus();
  }

  int getIconPosition(ClientDetailsPageState pageState, List<String> leadSourceIconsWhite) {
    return leadSourceIconsWhite.indexOf(pageState.leadSource);
  }
}

