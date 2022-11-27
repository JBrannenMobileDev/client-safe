import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoiceJobListItem.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class JobSelectionForm extends StatefulWidget {
  @override
  _JobSelectionFormState createState() {
    return _JobSelectionFormState();
  }
}

class _JobSelectionFormState extends State<JobSelectionForm> with AutomaticKeepAliveClientMixin {
  bool searchHasFocus = false;
  final searchTextController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (store) {
        store.dispatch(FetchAllInvoiceJobsAction(store.state.newInvoicePageState));
        searchTextController.text = store.state.newInvoicePageState.jobSearchText;
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "What job is this invoice for?",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 264.0),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Edit',
                        color: Color(ColorConstants.getPrimaryColor()),
                        onPressed: (){},
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        alignment: Alignment.center,
                        width: 225.0,
                        height: 45.0,
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          maxLines: 1,
                          autofocus: false,
                          controller: searchTextController,
                          cursorColor: Color(ColorConstants.getPrimaryColor()),
                          onChanged: (text) {
                            pageState.onJobSearchTextChanged(text);
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: "Job name",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(10.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(ColorConstants.getPrimaryColor()),
                                width: 1.0,
                              ),
                            ),
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
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black)),
                        )),
                  ],
                ),
                pageState.filteredJobs.length > 0 && pageState.isFinishedFetchingClients
                    ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 450.0,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      ListView.builder(
                        reverse: false,
                        padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                        shrinkWrap: true,
                        controller: _controller,
                        physics: ClampingScrollPhysics(),
                        itemCount: pageState.filteredJobs.length,
                        itemBuilder: _buildItem,
                      ),
                    ],
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
                      child: Text(
                        pageState.allClients.length > 0
                            ? "There are no matching jobs for the name entered."
                            : "You have not started any jobs yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    ClientSafeButton(
                      height: 50.0,
                      width: 200.0,
                      text: "Start a new job",
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
    UserOptionsUtil.showNewJobDialog(context);
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewJobPageState>(
    converter: (store) => NewJobPageState.fromStore(store),
    builder: (BuildContext context, NewJobPageState pageState) =>
        NewInvoiceJobListItem(index),
  );
}
