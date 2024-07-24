import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobClientListWidget.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/ColorConstants.dart';
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
            margin: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                NewJobTextField(
                  controller: firstNameTextController,
                  hintText: 'Client Name',
                  inputType: TextInputType.text,
                  height: 54.0,
                  onTextInputChanged: pageState.onClientFirstNameTextChanged!,
                  keyboardAction: TextInputAction.next,
                  capitalization: TextCapitalization.words,
                  focusNode: _firstNameFocus,
                  onFocusAction: onFirstNameAction,
                  inputTypeError: NewContactPageState.ERROR_FIRST_NAME_MISSING,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: MediaQuery.of(context).size.height - 179,
                  ),
                  child: (pageState.filteredClients?.length ?? 0) > 0 ? ListView.builder(
                    reverse: false,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 64.0),
                    shrinkWrap: true,
                    controller: _controller,
                    physics: const ScrollPhysics(),
                    itemCount: pageState.filteredClients!.length,
                    itemBuilder: _buildItem,
                  ) : Container(
                    margin: const EdgeInsets.only(top: 164),
                    child: LoadingAnimationWidget.fourRotatingDots(color: Color(ColorConstants.getPeachDark()), size: 32),
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
