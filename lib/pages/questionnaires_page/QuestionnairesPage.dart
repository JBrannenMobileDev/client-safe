import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/pages/contracts_page/ContractsActions.dart';
import 'package:dandylight/pages/contracts_page/ContractsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../widgets/TextDandyLight.dart';
import 'QuestionnaireListWidget.dart';

class QuestionnairesPage extends StatefulWidget {
  final String jobDocumentId;

  const QuestionnairesPage({Key key, this.jobDocumentId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionnairesPageState(jobDocumentId);
  }
}

class _QuestionnairesPageState extends State<QuestionnairesPage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final String jobDocumentId;

  _QuestionnairesPageState(this.jobDocumentId);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ContractsPageState>(
        onInit: (store) {
          store.dispatch(FetchContractsAction(store.state.contractsPageState));
        },
        converter: (Store<AppState> store) => ContractsPageState.fromStore(store),
        builder: (BuildContext context, ContractsPageState pageState) =>
            Scaffold(
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
                          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                          pinned: true,
                          elevation: 0.0,
                          centerTitle: true,
                          title: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: jobDocumentId != null ? 'Select A Questionnaire' : "Questionnaires",
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                          actions: <Widget>[
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 26.0),
                                height: 24.0,
                                width: 24.0,
                                child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getBlueDark()),),
                              ),
                            ),
                          ], systemOverlayStyle: SystemUiOverlayStyle.dark,
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            <Widget>[
                              pageState.contracts.isNotEmpty ? ListView.builder(
                                reverse: false,
                                padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 64.0),
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: const ClampingScrollPhysics(),
                                key: _listKey,
                                itemCount: pageState.contracts.length,
                                itemBuilder: _buildItem,
                              ) :
                              Padding(
                                padding: const EdgeInsets.only(left: 64.0, top: 32.0, right: 64.0),
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
                  pageState.contracts.isEmpty ? Container(
                    margin: const EdgeInsets.only(bottom: 48),
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {

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
                  ) : const SizedBox(),
                ],
              ),
            ),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, ContractsPageState>(
      converter: (store) => ContractsPageState.fromStore(store),
      builder: (BuildContext context, ContractsPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(top: 0.0, bottom: 8.0),
            child: QuestionnaireListWidget(pageState.contracts.elementAt(index), pageState, onOptionSelected, Color(ColorConstants.getBlueLight()), Color(ColorConstants.getPrimaryBlack())),
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
