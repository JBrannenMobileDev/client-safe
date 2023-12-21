import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/pages/contracts_page/ContractsActions.dart';
import 'package:dandylight/pages/contracts_page/ContractsPageState.dart';
import 'package:dandylight/pages/contracts_page/HowToBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../widgets/TextDandyLight.dart';
import 'NewContractOptionsBottomSheet.dart';
import 'ContractListWidget.dart';

class ContractsPage extends StatefulWidget {
  final String jobDocumentId;

  ContractsPage({this.jobDocumentId = null});

  @override
  State<StatefulWidget> createState() {
    return _ContractsPageState(jobDocumentId);
  }
}

class _ContractsPageState extends State<ContractsPage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final String jobDocumentId;

  _ContractsPageState(this.jobDocumentId);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void _showGetStartedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return NewContractOptionsBottomSheet();
      },
    );
  }

  void _showHowToSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return HowToBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ContractsPageState>(
        onInit: (store) {
          store.dispatch(FetchContractsAction(store.state.contractsPageState));
        },
        converter: (Store<AppState> store) => ContractsPageState.fromStore(store),
        builder: (BuildContext context, ContractsPageState pageState) =>
            Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  _showHowToSheet(context);
                },
                label: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: "HOW-TO",
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                backgroundColor: Color(ColorConstants.getPeachDark()),
              ),
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          iconTheme: IconThemeData(
                            color: Color(ColorConstants.getBlueDark()), //change your color here
                          ),
                          brightness: Brightness.light,
                          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                          pinned: true,
                          centerTitle: true,
                          elevation: 0.0,
                          title: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: jobDocumentId != null ? 'Select A Contract' : "Contracts",
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                          actions: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showGetStartedBottomSheet(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 26.0),
                                height: 24.0,
                                width: 24.0,
                                child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getBlueDark()),),
                              ),
                            ),
                          ],
                        ),
                        SliverList(
                          delegate: new SliverChildListDelegate(
                            <Widget>[
                              pageState.contracts.length > 0 ? ListView.builder(
                                reverse: false,
                                padding: new EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 64.0),
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: ClampingScrollPhysics(),
                                key: _listKey,
                                itemCount: pageState.contracts.length,
                                itemBuilder: _buildItem,
                              ) :
                              Padding(
                                padding: EdgeInsets.only(left: 64.0, top: 32.0, right: 64.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.SMALL_TEXT,
                                  text: "You have not created any contracts yet.",
                                  textAlign: TextAlign.center,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pageState.contracts.length == 0 ? Container(
                    margin: EdgeInsets.only(bottom: 48),
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        _showGetStartedBottomSheet(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 216,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27),
                            color: Color(ColorConstants.getBlueDark())
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: "New Contract",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                ],
              ),
            ),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, ContractsPageState>(
      converter: (store) => ContractsPageState.fromStore(store),
      builder: (BuildContext context, ContractsPageState pageState) =>
          Container(
            margin: EdgeInsets.only(top: 0.0, bottom: 8.0),
            child: ContractListWidget(pageState.contracts.elementAt(index), pageState, onOptionSelected, Color(ColorConstants.getBlueLight()), Color(ColorConstants.getPrimaryBlack())),
          ),
    );
  }

  onOptionSelected(ContractsPageState pageState, BuildContext context, Contract contract) {
    if(jobDocumentId != null) {
      pageState.onSaveToJobSelected(contract, jobDocumentId);
      Navigator.of(context).pop();
    } else {
      NavigationUtil.onContractSelected(context, contract, contract.contractName, false, jobDocumentId, null);
    }
  }
}
