import 'package:dandylight/widgets/TextFieldSimple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import 'NewSessionTypePageState.dart';

class SessionTypeNameSelectionWidget extends StatefulWidget{

  @override
  _SessionTypeNameSelectionWidgetState createState() {
    return _SessionTypeNameSelectionWidgetState();
  }
}

class _SessionTypeNameSelectionWidgetState extends State<SessionTypeNameSelectionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final descriptionTextController = TextEditingController();

  _SessionTypeNameSelectionWidgetState();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewSessionTypePageState>(
      onInit: (store) {
        descriptionTextController.text = store.state.newSessionTypePageState!.title!;
      },
      converter: (store) => NewSessionTypePageState.fromStore(store),
      builder: (BuildContext context, NewSessionTypePageState pageState) =>
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              TextFieldSimple(
                controller: descriptionTextController,
                hintText: 'Name',
                inputType: TextInputType.text,
                focusNode: null,
                onFocusAction: null,
                onTextInputChanged: pageState.onTitleChanged!,
                keyboardAction: TextInputAction.done,
                capitalization: TextCapitalization.words,
              ),
            ],
          ),
          ),
    );
  }
}