import 'package:dandylight/models/Question.dart';
import 'package:dandylight/pages/new_question_page/NewQuestionPageState.dart';
import 'package:dandylight/pages/new_questionnaire_page/NewQuestionListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../widgets/TextDandyLight.dart';


class AddCheckboxOptionBottomSheet extends StatefulWidget {
  const AddCheckboxOptionBottomSheet({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _AddCheckboxOptionBottomSheetState();
  }
}

class _AddCheckboxOptionBottomSheetState extends State<AddCheckboxOptionBottomSheet> with TickerProviderStateMixin {
  final choiceTextController = TextEditingController();
  final FocusNode choiceFocus = FocusNode();
  String newChoice = '';

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, NewQuestionPageState>(
    converter: (Store<AppState> store) => NewQuestionPageState.fromStore(store),
    builder: (BuildContext context, NewQuestionPageState pageState) =>
         Container(
           height: 496,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
             child: Column(
               children: [
                 Container(
                   margin: const EdgeInsets.only(top: 16),
                   alignment: Alignment.center,
                   child: TextDandyLight(
                     type: TextDandyLight.LARGE_TEXT,
                     text: 'Add a choice',
                     color: Color(ColorConstants.getPrimaryBlack()),
                   ),
                 ),
                  Container(
                     margin: const EdgeInsets.only(top: 32.0),
                     alignment: Alignment.center,
                     width: 259.0,
                     height: 45.0,
                     child: TextField(
                       style: TextStyle(
                           fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                           fontFamily: TextDandyLight.getFontFamily(),
                           fontWeight: TextDandyLight.getFontWeight(),
                           color: Color(ColorConstants.getPrimaryBlack())),
                       textInputAction: TextInputAction.done,
                       maxLines: 1,
                       autofocus: true,
                       cursorColor: Color(ColorConstants.getBlueDark()),
                       controller: choiceTextController,
                       onChanged: (text) {
                         setState(() {
                           newChoice = text;
                         });
                       },
                       decoration: InputDecoration(
                         alignLabelWithHint: true,
                         hintText: "choice name",
                         labelStyle: TextStyle(
                             fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                             fontFamily: TextDandyLight.getFontFamily(),
                             fontWeight: TextDandyLight.getFontWeight(),
                             color: Color(ColorConstants.getPrimaryBlack())),
                         fillColor: Color(ColorConstants.getPrimaryWhite()),
                         contentPadding: EdgeInsets.all(10.0),
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(25.0),
                           borderSide: BorderSide(
                             color: Color(ColorConstants.getBlueDark()),
                             width: 1.0,
                           ),
                         ),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(25.0),
                           borderSide: BorderSide(
                             color: Color(ColorConstants.getBlueLight()),
                             width: 1.0,
                           ),
                         ),
                       ),
                       keyboardType: TextInputType.text,
                       textCapitalization: TextCapitalization.sentences,
                       onSubmitted: (text) {
                         onChoiceAdded(pageState);
                       },
                     )),
                 GestureDetector(
                   onTap: () {
                     onChoiceAdded(pageState);
                   },
                   child: Container(
                     margin: const EdgeInsets.only(bottom: 16, top: 32),
                     alignment: Alignment.center,
                     height: 48,
                     width: 164,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(26),
                         color: Color(ColorConstants.getBlueDark())
                     ),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Add choice',
                       color: Color(ColorConstants.getPrimaryWhite()),
                     ),
                   ),
                 )
               ],
             ),
         ),
    );

  void onChoiceAdded(NewQuestionPageState pageState) {
    pageState.onCheckBoxChoiceAdded!(choiceTextController.text);
    Navigator.of(context).pop();
  }
}