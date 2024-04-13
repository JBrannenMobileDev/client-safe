import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/LeadSource.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class LeadSourceSelectionPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LeadSourceSelectionPage();
  }
}

class _LeadSourceSelectionPage extends State<LeadSourceSelectionPage> {
  final notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();
  int selectedIndex = -1;

  final List<String> _chipLabels = [
    LeadSource.TYPE_INSTAGRAM,
    LeadSource.TYPE_WORD_OF_MOUTH,
    LeadSource.TYPE_FACEBOOK,
    LeadSource.TYPE_TIKTOK,
    LeadSource.TYPE_YOUTUBE,
    LeadSource.TYPE_APP_STORE,
    LeadSource.TYPE_WEB_SEARCH,
    LeadSource.TYPE_EMAIL,
    LeadSource.TYPE_DANDYLIGHT_BLOG,
    LeadSource.TYPE_PINTEREST,
    LeadSource.TYPE_OTHER,
  ];


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnBoardingPageState>(
      onInit: (store) {
        notesController.value = notesController.value.copyWith(text:store.state.jobDetailsPageState!.notes);
      },
      converter: (store) => OnBoardingPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingPageState pageState) =>
        Container(
          margin: const EdgeInsets.only(left: 16, top: 54, right: 16, bottom: 0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 24, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      isBold: true,
                      text: "How did you hear about DandyLight?",
                      color: Color(ColorConstants.getPrimaryBlack()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      children: List<Widget>.generate(
                        _chipLabels.length,
                            (int index) {
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ChoiceChip(
                                label: TextDandyLight(
                                  type: TextDandyLight.SMALL_TEXT,
                                  text: _chipLabels.elementAt(index),
                                  textAlign: TextAlign.start,
                                  color: Color(index == selectedIndex ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                                ),
                                backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                selectedColor: Color(ColorConstants.getPeachDark()),
                                selected: index == selectedIndex,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if(selected) {
                                      selectedIndex = index;
                                    } else {
                                      selectedIndex = -1;
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if(selectedIndex >= 0) {
                    EventSender().sendEvent(
                        eventName: EventNames.ON_BOARDING_LEAD_SOURCE_SELECTED,
                        properties: {EventNames.ON_BOARDING_LEAD_SOURCE_SELECTED_PARAM : _chipLabels.elementAt(selectedIndex)}
                    );
                    pageState.setPagerIndex!(2);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 32.0),
                  alignment: Alignment.center,
                  height: 54.0,
                  decoration: BoxDecoration(
                      color: Color(selectedIndex >= 0 ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                      borderRadius: BorderRadius.circular(36.0)),
                  child: TextDandyLight(
                    text: 'Continue',
                    type: TextDandyLight.LARGE_TEXT,
                    color: Color(selectedIndex >= 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
            ] ,
          ),
    ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
