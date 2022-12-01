import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
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

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
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
  final FocusNode _firstNameFocus = FocusNode();

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(FetchAllAction(store.state.newJobPageState));
        firstNameTextController.text = store.state.newJobPageState.clientFirstName;
      },
      onDidChange: (previous, current) {
        if(current.selectedClient != null && previous.selectedClient == null) {
          firstNameTextController.value = firstNameTextController.value.copyWith(
            text: current.clientFirstName,
            selection: TextSelection.collapsed(offset: current.clientFirstName.length),
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
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 4.0),
                  height: 54.0,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Color(ColorConstants.getBlueDark()),
                  ),
                  child: TextButton(
                    onPressed: () {
                      UserOptionsUtil.showNewContactDialog(context, true);
                      EventSender().sendEvent(eventName: EventNames.BT_ADD_NEW_CONTACT, properties: {EventNames.CONTACT_PARAM_COMING_FROM : "New Job Page"});
                    },
                    child: Text(
                      'Add New Contact',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Or',
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
                  hintText: 'Search Your Contacts',
                  inputType: TextInputType.text,
                  height: 64.0,
                  onTextInputChanged: pageState.onClientFirstNameTextChanged,
                  keyboardAction: TextInputAction.next,
                  capitalization: TextCapitalization.words,
                  focusNode: _firstNameFocus,
                  onFocusAction: onFirstNameAction,
                  inputTypeError: NewContactPageState.ERROR_FIRST_NAME_MISSING,
                ),
                ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 65.0,
                          maxHeight: 371.0,
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
