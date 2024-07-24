import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/Client.dart';
import '../../widgets/TextDandyLight.dart';
import '../../widgets/TextFieldSimple.dart';
import 'NewJobPageState.dart';

class LeadSourceBody extends StatefulWidget {
  @override
  _LeadSourceSelection createState() {
    return _LeadSourceSelection();
  }
}

class _LeadSourceSelection extends State<LeadSourceBody>
    with AutomaticKeepAliveClientMixin {
  final customLeadController = TextEditingController();
  final FocusNode _customLeadFocusNode = FocusNode();

  List<String> _chipLabels = Client.getLeadSources();

  bool isSelected(int index, NewJobPageState pageState) {
    return _chipLabels.elementAt(index) == pageState.leadSource;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 0.0, right: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 14.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "How did ${(pageState.deviceContactFirstName?.isNotEmpty ?? false) ? pageState.deviceContactFirstName : 'this client'} hear about your business?",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
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
                          backgroundColor: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
                          checkmarkColor: Color(isSelected(index, pageState) ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                          selectedColor: Color(isSelected(index, pageState) ? ColorConstants.getPrimaryGreyDark() : ColorConstants.getBlueLight()),
                          selected: pageState.leadSource == _chipLabels.elementAt(index),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                pageState.onLeadSourceSelected!(_chipLabels.elementAt(index));
                                Navigator.of(context).pop();
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(isSelected(index, pageState) ? ColorConstants.getPrimaryGreyDark() : ColorConstants.getBlueLight()), width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 32, right: 32),
              child: pageState.leadSource == Client.LEAD_SOURCE_OTHER ? TextFieldSimple(
                controller: customLeadController,
                hintText: 'Custom name',
                inputType: TextInputType.phone,
                hasError: false,
                focusNode: _customLeadFocusNode,
                onTextInputChanged: pageState.onLeadSourceSelected!,
                keyboardAction: TextInputAction.done,
                capitalization: TextCapitalization.words,
              ) : const SizedBox(),
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

  int getIconPosition(NewJobPageState pageState, List<String> leadSourceIconsWhite) {
    return leadSourceIconsWhite.indexOf(pageState.leadSource!);
  }
}
