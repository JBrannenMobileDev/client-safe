import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/LeadSource.dart';
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

  List<String> _chipLabels = [
    LeadSource.TYPE_INSTAGRAM,
    LeadSource.TYPE_WORD_OF_MOUTH,
    LeadSource.TYPE_FACEBOOK,
    LeadSource.TYPE_TIKTOK,
    LeadSource.TYPE_YOUTUBE,
    LeadSource.TYPE_APP_STORE,
    LeadSource.TYPE_WEB_SEARCH,
    LeadSource.TYPE_EMAIL,
    LeadSource.TYPE_TWITTER,
    LeadSource.TYPE_OTHER,
  ];


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnBoardingPageState>(
      onInit: (store) {
        notesController.value = notesController.value.copyWith(text:store.state.jobDetailsPageState.notes);
      },
      converter: (store) => OnBoardingPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16, top: 54, right: 16, bottom: 0),
            child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 24),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        isBold: true,
                        text: "How did you hear about DandyLight?",
                        color: Color(ColorConstants.getPrimaryBlack()),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: List<Widget>.generate(
                          _chipLabels.length,
                              (int index) {
                            return Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  child: ChoiceChip(
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
                                    if(selected) {
                                      pageState.onLeadSourceSelected(_chipLabels.elementAt(index));
                                      pageState.setPagerIndex(1);
                                    }
                                  },
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
            ),
          ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
