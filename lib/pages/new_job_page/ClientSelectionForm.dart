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
import '../../widgets/TextDandyLight.dart';
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
  bool searchSelected = false;

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(FetchAllAction(store.state.newJobPageState));
        firstNameTextController.text = store.state.newJobPageState!.clientFirstName!;
      },
      onDidChange: (previous, current) {
        if(current.selectedClient != null && previous!.selectedClient == null) {
          firstNameTextController.value = firstNameTextController.value.copyWith(
            text: current.clientFirstName,
            selection: TextSelection.collapsed(offset: current.clientFirstName!.length),
          );
        }
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(left: 26.0, right: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: "Who is this job for?",
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8.0),
                  height: 48.0,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Color(ColorConstants.getBlueDark()),
                  ),
                  child: TextButton(
                    onPressed: () {
                      UserOptionsUtil.showNewContactDialog(context, true);
                      EventSender().sendEvent(eventName: EventNames.BT_ADD_NEW_CONTACT, properties: {EventNames.CONTACT_PARAM_COMING_FROM : "New Job Page"});
                    },
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Add New Contact',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
                !searchSelected ? Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Or',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ) : const SizedBox(),
                !searchSelected ? Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 8.0),
                  height: 48.0,
                  width: 248,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Color(ColorConstants.getBlueDark()),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        searchSelected = true;
                      });
                    },
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Search DandyLight Contacts',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ) : const SizedBox(),
                searchSelected ? NewJobTextField(
                  controller: firstNameTextController,
                  hintText: 'Client Name',
                  inputType: TextInputType.text,
                  height: 64.0,
                  onTextInputChanged: pageState.onClientFirstNameTextChanged!,
                  keyboardAction: TextInputAction.next,
                  capitalization: TextCapitalization.words,
                  focusNode: _firstNameFocus,
                  onFocusAction: onFirstNameAction,
                  inputTypeError: NewContactPageState.ERROR_FIRST_NAME_MISSING,
                ) : const SizedBox(),
                searchSelected ? ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 65.0,
                          maxHeight: 429.0,
                        ),
                        child: ListView.builder(
                          reverse: false,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 64.0),
                          shrinkWrap: true,
                          controller: _controller,
                          physics: const ClampingScrollPhysics(),
                          itemCount: pageState.filteredClients!.length,
                          itemBuilder: _buildItem,
                        ),
                ) : const SizedBox(),
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
