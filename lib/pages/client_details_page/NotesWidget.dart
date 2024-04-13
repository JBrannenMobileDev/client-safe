import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';

class NotesWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _NotesWidgetPage();
  }
}

class _NotesWidgetPage extends State<NotesWidget> {
  final notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientDetailsPageState>(
      onInit: (store) {
        notesController.value = notesController.value.copyWith(text:store.state.clientDetailsPageState!.client!.notes);
      },
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
            height: 150,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 24.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Notes',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
