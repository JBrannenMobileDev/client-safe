import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/Questionnaire.dart';
import '../../widgets/TextDandyLight.dart';
import 'QuestionnaireListWidget.dart';
import 'QuestionnairesActions.dart';
import 'QuestionnairesPageState.dart';

class QuestionnairesPage extends StatefulWidget {
  final String jobDocumentId;
  final bool addToJobNew;

  const QuestionnairesPage({Key key, this.jobDocumentId, this.addToJobNew}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionnairesPageState(jobDocumentId, addToJobNew);
  }
}

class _QuestionnairesPageState extends State<QuestionnairesPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  ScrollController _scrollController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final String jobDocumentId;
  final bool addToJobNew;

  _QuestionnairesPageState(this.jobDocumentId, this.addToJobNew);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, QuestionnairesPageState>(
        onInit: (store) {
          store.dispatch(FetchQuestionnairesAction(store.state.questionnairesPageState));
        },
        converter: (Store<AppState> store) => QuestionnairesPageState.fromStore(store),
        builder: (BuildContext context, QuestionnairesPageState pageState) =>
            WillPopScope(
                child: Scaffold(
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
                                    NavigationUtil.onQuestionnaireSelected(context, null, 'Questionnaire name', true, jobDocumentId, null);
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
                                  pageState.questionnaires.isNotEmpty ? ListView.builder(
                                    reverse: false,
                                    padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 64.0),
                                    shrinkWrap: true,
                                    controller: _scrollController,
                                    physics: const ClampingScrollPhysics(),
                                    key: _listKey,
                                    itemCount: pageState.questionnaires.length,
                                    itemBuilder: _buildItem,
                                  ) :
                                  Padding(
                                    padding: const EdgeInsets.only(left: 64.0, top: 32.0, right: 64.0),
                                    child: TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: "You have not created any questionnaires yet.",
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
                      pageState.questionnaires.isEmpty ? Container(
                        margin: const EdgeInsets.only(bottom: 48),
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            NavigationUtil.onQuestionnaireSelected(context, null, 'Questionnaire name', true, jobDocumentId, null);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 232,
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27),
                                color: Color(ColorConstants.getBlueDark())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: "New Questionnaire",
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                      ) : const SizedBox(),
                    ],
                  ),
                ),
                onWillPop: () async {
                  pageState.unsubscribe();
                  return true;
                }),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, QuestionnairesPageState>(
      converter: (store) => QuestionnairesPageState.fromStore(store),
      builder: (BuildContext context, QuestionnairesPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(top: 0.0, bottom: 8.0),
            child: QuestionnaireListWidget(pageState.questionnaires.elementAt(index), pageState, onOptionSelected, Color(ColorConstants.getBlueLight()), Color(ColorConstants.getPrimaryBlack()), addToJobNew, jobDocumentId),
          ),
    );
  }

  onOptionSelected(QuestionnairesPageState pageState, BuildContext context, Questionnaire questionnaire) {
    if(jobDocumentId != null) {
      pageState.onSaveToJobSelected(questionnaire, jobDocumentId);
      Navigator.of(context).pop();
    } else {
      NavigationUtil.onQuestionnaireSelected(context, questionnaire, questionnaire.title, false, jobDocumentId, null);
    }
  }
}
