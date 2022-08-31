import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobClientListWidget.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../new_contact_pages/NewContactPageState.dart';

class ClientSelectionForm extends StatefulWidget {
  @override
  _ClientSelectionFormState createState() {
    return _ClientSelectionFormState();
  }
}

class _ClientSelectionFormState extends State<ClientSelectionForm>
    with AutomaticKeepAliveClientMixin {
  bool searchHasFocus = false;
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(FetchAllAction(store.state.newJobPageState));
        firstNameTextController.text = store.state.newJobPageState.clientFirstName;
        lastNameTextController.text = store.state.newJobPageState.clientLastName;
      },
      onDidChange: (previous, current) {
        if(current.selectedClient != null && previous.selectedClient == null) {
          firstNameTextController.value = firstNameTextController.value.copyWith(
            text: current.clientFirstName,
            selection: TextSelection.collapsed(offset: current.clientFirstName.length),
          );
          lastNameTextController.value = lastNameTextController.value.copyWith(
            text: current.clientLastName,
            selection: TextSelection.collapsed(offset: current.clientLastName.length),
          );
        }
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 26.0, right: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Who is this job for?",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                NewJobTextField(
                  controller: firstNameTextController,
                  hintText: "First Name",
                  inputType: TextInputType.text,
                  height: 64.0,
                  onTextInputChanged: pageState.onClientFirstNameTextChanged,
                  keyboardAction: TextInputAction.next,
                  capitalization: TextCapitalization.words,
                  focusNode: _firstNameFocus,
                  onFocusAction: onFirstNameAction,
                  inputTypeError: NewContactPageState.ERROR_FIRST_NAME_MISSING,
                ),
                NewJobTextField(
                    controller: lastNameTextController,
                    hintText: "Last Name",
                    inputType: TextInputType.text,
                    height: 64.0,
                    onTextInputChanged: pageState.onClientLastNameTextChanged,
                    keyboardAction: TextInputAction.next,
                    capitalization: TextCapitalization.words,
                    focusNode: _lastNameFocus,
                    onFocusAction: onLastNameAction,
                    inputTypeError: NewContactPageState.NO_ERROR
                ),
                ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 65.0,
                          maxHeight: 317.0,
                        ),
                        child: ListView.builder(
                          reverse: false,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 64.0),
                          shrinkWrap: true,
                          controller: _controller,
                          physics: ClampingScrollPhysics(),
                          itemCount: pageState.filteredClients.length,
                          itemBuilder: _buildItem,
                        ),
                ),
              ],
            ),
          ),
    );
  }

  void onFirstNameAction(){
    _firstNameFocus.unfocus();
    FocusScope.of(context).requestFocus(_lastNameFocus);
  }

  void onLastNameAction(){
    _lastNameFocus.unfocus();
  }

  void onAddNewContactPressed() {
    Navigator.of(context).pop();
    UserOptionsUtil.showNewContactDialog(context);
  }

  @override
  bool get wantKeepAlive => true;

  int getClientIndex(Client selectedClient, List<Client> filteredClients) {
    for(Client client in filteredClients){
      if(client.documentId == selectedClient.documentId) return filteredClients.indexOf(client);
    }
    return 0;
  }
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewJobPageState>(
    converter: (store) => NewJobPageState.fromStore(store),
    builder: (BuildContext context, NewJobPageState pageState) =>
        NewJobClientListWidget(index),
  );
}
