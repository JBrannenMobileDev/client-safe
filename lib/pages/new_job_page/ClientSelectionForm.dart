import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/common_widgets/ClientSafeButton.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobClientListWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ClientSelectionForm extends StatefulWidget {
  @override
  _ClientSelectionFormState createState() {
    return _ClientSelectionFormState();
  }
}

class _ClientSelectionFormState extends State<ClientSelectionForm>
    with AutomaticKeepAliveClientMixin {
  bool searchHasFocus = false;
  final searchTextController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(FetchAllClientsAction(store.state.newJobPageState));
        searchTextController.text =
            store.state.newJobPageState.clientSearchText;
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 26.0, right: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    searchHasFocus
                        ? Container(
                        margin: EdgeInsets.only(top: 8.0),
                        alignment: Alignment.center,
                        width: 259.0,
                        height: 45.0,
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          maxLines: 1,
                          autofocus: true,
                          controller: searchTextController,
                          onChanged: (text) {
                            pageState.onClientSearchTextChanged(text);
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: "Name",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(ColorConstants.getPrimaryColor()),
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: new TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black)),
                        ))
                        : Text(
                      "What client is this job for?",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    searchHasFocus
                        ? Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Close',
                        color: Color(ColorConstants.getPrimaryColor()),
                        onPressed: () {
                          setState(() {
                            searchHasFocus = false;
                            searchTextController.text = "";
                          });
                          pageState.onClientSearchTextChanged("");
                        },
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Search',
                        color: Color(ColorConstants.getPrimaryColor()),
                        onPressed: () {
                          setState(() {
                            searchHasFocus = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    pageState.selectedClient != null
                        ? pageState.selectedClient.getClientFullName()
                        : "",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryColor()),
                    ),
                  ),
                ),
                pageState.filteredClients.length > 0 && pageState.isFinishedFetchingClients
                    ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 300.0,
                  ),
                  child: ListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                    shrinkWrap: true,
                    controller: _controller,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.filteredClients.length,
                    itemBuilder: _buildItem,
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
                      child: Text(
                        pageState.allClients.length > 0
                            ? "There are no matching clients for the name entered."
                            : "You have not added any clients yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    ClientSafeButton(
                      height: 50.0,
                      width: 200.0,
                      text: "Add New Client",
                      marginLeft: 0.0,
                      marginRight: 0.0,
                      marginBottom: 0.0,
                      marginTop: 32.0,
                      onPressed: onAddNewContactPressed,
                      urlText: "",
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void onAddNewContactPressed() {
    Navigator.of(context).pop();
    UserOptionsUtil.showNewContactDialog(context);
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewJobPageState>(
    converter: (store) => NewJobPageState.fromStore(store),
    builder: (BuildContext context, NewJobPageState pageState) =>
        NewJobClientListWidget(index),
  );
}
