import 'package:dandylight/models/Question.dart';
import 'package:dandylight/pages/new_question_page/NewQuestionPageState.dart';
import 'package:dandylight/pages/new_questionnaire_page/NewQuestionListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../widgets/TextDandyLight.dart';


class TypeSelectionBottomSheet extends StatefulWidget {
  const TypeSelectionBottomSheet({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _TypeSelectionBottomSheetState();
  }
}

class _TypeSelectionBottomSheetState extends State<TypeSelectionBottomSheet> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, NewQuestionPageState>(
    converter: (Store<AppState> store) => NewQuestionPageState.fromStore(store),
    builder: (BuildContext context, NewQuestionPageState pageState) =>
         Container(
           height: 564,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
             child: ListView.builder(
               itemCount: Question.allTypes().length,
               itemBuilder: (BuildContext context, int index) {
                 return GestureDetector(
                   onTap: () {
                     pageState.onTypeChanged!(Question.allTypes().elementAt(index));
                     Navigator.of(context).pop();
                   },
                   child: ListTile(
                     leading: NewQuestionListWidget.getIconFromType(Question.allTypes().elementAt(index)),
                     title: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: Question.allTypes().elementAt(index),
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                 );
               },
             ),
         ),
    );
}