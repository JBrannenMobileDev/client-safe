import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/Client.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewContactTextField.dart';

class LeadSourceSelection extends StatefulWidget {
  @override
  _LeadSourceSelection createState() {
    return _LeadSourceSelection();
  }
}

class _LeadSourceSelection extends State<LeadSourceSelection>
    with AutomaticKeepAliveClientMixin {
  final customLeadController = TextEditingController();
  final FocusNode _customLeadFocusNode = FocusNode();

  List<String> _chipLabels = Client.getLeadSources();

  bool isSelected(int index, NewContactPageState pageState) {
    return _chipLabels.elementAt(index) == pageState.leadSource;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewContactPageState>(
      onInit: (store) {
        customLeadController.value = customLeadController.value.copyWith(text:store.state.newContactPageState!.customLeadSourceName);
      },
      onWillChange: (statePrevious, stateNew) {
        customLeadController.value = customLeadController.value.copyWith(text:stateNew.customLeadSourceName);
      },
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 0.0, right: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "How did " +
                    pageState.newContactFirstName! +
                    " hear about your business?",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Container(
                child: Wrap(
                  alignment: WrapAlignment.center,
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
                                color: Color(isSelected(index, pageState) ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                              ),
                            ],
                          ),
                          backgroundColor:
                          Color(ColorConstants.primary_bg_grey),
                          selectedColor: Color(isSelected(index, pageState) ? ColorConstants.getBlueDark() : ColorConstants.getBlueLight()),
                          selected: pageState.leadSource == _chipLabels.elementAt(index),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                pageState.onLeadSourceSelected!(_chipLabels.elementAt(index));
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
              margin: EdgeInsets.only(left: 32, right: 32),
              child: pageState.leadSource == Client.LEAD_SOURCE_OTHER ? NewContactTextField(
                  customLeadController,
                  "Custom Name",
                  TextInputType.text,
                  66.0,
                  pageState.onCustomLeadSourceTextChanged!,
                  NewContactPageState.NO_ERROR,
                  TextInputAction.done,
                  _customLeadFocusNode,
                  onAction,
                  TextCapitalization.words,
                  null,
                  true,
                ColorConstants.getBlueLight(),
              ) : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  void onAction(){
    _customLeadFocusNode.unfocus();
  }

  @override
  bool get wantKeepAlive => true;

  int getIconPosition(NewContactPageState pageState, List<String> leadSourceIconsWhite) {
    return leadSourceIconsWhite.indexOf(pageState.leadSource!);
  }
}
