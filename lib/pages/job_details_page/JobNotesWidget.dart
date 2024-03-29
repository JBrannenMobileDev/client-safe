import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';
import 'JobDetailsPageState.dart';

class JobNotesWidget extends StatefulWidget {
  const JobNotesWidget({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _NotesWidgetPage();
  }
}

class _NotesWidgetPage extends State<JobNotesWidget> {
  final notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        notesController.value = notesController.value.copyWith(text:store.state.jobDetailsPageState!.job!.notes);
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
            height: 150,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 24.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Notes',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: DandyLightTextField(
                    notesController,
                    "",
                    TextInputType.text,
                    110.0,
                    pageState.onNotesTextChanged!,
                    NewContactPageState.NO_ERROR,
                    TextInputAction.done,
                    _notesFocusNode,
                    onAction,
                    TextCapitalization.sentences,
                    null,
                    true,
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
