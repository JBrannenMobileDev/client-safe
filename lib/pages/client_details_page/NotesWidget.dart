import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../AppState.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/styles/Styles.dart';
import '../new_contact_pages/NewContactPageState.dart';
import '../new_contact_pages/NewContactTextField.dart';

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
        notesController.value = notesController.value.copyWith(text:store.state.clientDetailsPageState.client.notes);
      },
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
            height: 150,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 24.0),
                  child: Text(
                    'Notes',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: NewContactTextField(
                    notesController,
                    "",
                    TextInputType.text,
                    111.0,
                    pageState.onNotesTextChanged,
                    NewContactPageState.NO_ERROR,
                    TextInputAction.done,
                    _notesFocusNode,
                    onAction,
                    TextCapitalization.sentences,
                    null,
                    true,
                    ColorConstants.getPrimaryWhite(),
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
