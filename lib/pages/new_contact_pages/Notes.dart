import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactTextField.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'NewContactTextField.dart';

class Notes extends StatefulWidget {
  @override
  _Notes createState() {
    return _Notes();
  }
}

class _Notes extends State<Notes> with AutomaticKeepAliveClientMixin {
  final notesController = TextEditingController();
  final FocusNode _notesFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewContactPageState>(
      onInit: (store) {
        notesController.text = store.state.newContactPageState.notes;
      },
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Do you have any additional information you want to remember about " +
                    pageState.newContactFirstName +
                    "? Interests? Passions? Important details?",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            NewContactTextField(
                notesController,
                "Notes",
                TextInputType.multiline,
                124.0,
                pageState.onNotesChanged,
                NewContactPageState.NO_ERROR,
                TextInputAction.done,
                _notesFocus,
                onNotesAction,
                TextCapitalization.sentences,
                null,
                true),
          ],
        ),
      ),
    );
  }

  void onNotesAction(){
    _notesFocus.unfocus();
  }

  @override
  bool get wantKeepAlive => true;
}
