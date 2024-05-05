import 'package:dandylight/models/Question.dart';
import 'package:dandylight/pages/new_question_page/NewQuestionPageState.dart';
import 'package:dandylight/pages/new_questionnaire_page/NewQuestionListWidget.dart';
import 'package:dandylight/pages/questionnaires_page/QuestionnairesPageState.dart';
import 'package:dandylight/pages/questionnaires_page/SendQuestionnaireOptionsBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../models/Questionnaire.dart';
import '../../widgets/TextDandyLight.dart';
import 'JobSelectionListItem.dart';


class SendQuestionnaireBottomSheet extends StatefulWidget {
  final Questionnaire? questionnaire;

  const SendQuestionnaireBottomSheet(this.questionnaire, {Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _SendQuestionnaireBottomSheetState(questionnaire);
  }
}

class _SendQuestionnaireBottomSheetState extends State<SendQuestionnaireBottomSheet> with TickerProviderStateMixin {
  static const String INITIAL_STATE = 'initialState';
  static const String SHARE_VIA_CLIENT_PORTAL_STATE = 'clientPortalState';
  static const String SHARE_DIRECTLY_STATE = 'shareDirectlyState';
  String? viewState;

  final searchTextController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final choiceTextController = TextEditingController();
  final FocusNode choiceFocus = FocusNode();
  String newChoice = '';

  final Questionnaire? questionnaire;

  _SendQuestionnaireBottomSheetState(this.questionnaire);

  @override
  void initState() {
    super.initState();
    viewState = INITIAL_STATE;
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, QuestionnairesPageState>(
    converter: (Store<AppState> store) => QuestionnairesPageState.fromStore(store),
    builder: (BuildContext context, QuestionnairesPageState pageState) =>
        Container(
          height: getSheetHeight(viewState!),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              color: Color(ColorConstants.getPrimaryWhite())),
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
          child: buildViewForState(pageState),
        ),
    );

  Widget buildViewForState(QuestionnairesPageState pageState) {
    Widget result = const SizedBox();
    switch(viewState) {
      case INITIAL_STATE:
        result = buildInitialView();
        break;
      case SHARE_VIA_CLIENT_PORTAL_STATE:
        result = buildClientPortalView(pageState);
        break;
      case SHARE_DIRECTLY_STATE:
        result = buildShareDirect(pageState);
        break;
    }
    return result;
  }

  Widget buildInitialView() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: 'Select an option',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              viewState = SHARE_VIA_CLIENT_PORTAL_STATE;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16, top: 32),
            alignment: Alignment.center,
            height: 48,
            width: 264,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Color(ColorConstants.getBlueDark())
            ),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'Send via Client Portal',
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              viewState = SHARE_DIRECTLY_STATE;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            alignment: Alignment.center,
            height: 48,
            width: 264,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Color(ColorConstants.getBlueDark())
            ),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'Send directly',
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildClientPortalView(QuestionnairesPageState pageState) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 8.0, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: "What job is this questionnaire for?",
            textAlign: TextAlign.start,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 65.0,
              maxHeight: 450.0,
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                  shrinkWrap: true,
                  controller: _controller,
                  physics: const ClampingScrollPhysics(),
                  itemCount: pageState.activeJobs?.length ?? 0,
                  itemBuilder: (context, index) {
                    return JobSelectionListItem(index, questionnaire!);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  double getSheetHeight(String viewState) {
    double result = 264;
    if(viewState == INITIAL_STATE) result = 264;
    if(viewState == SHARE_VIA_CLIENT_PORTAL_STATE) result = 550;
    if(viewState == SHARE_DIRECTLY_STATE) result = 764;
    return result;
  }

  Widget buildShareDirect(QuestionnairesPageState pageState) {
    return SendQuestionnaireOptionsBottomSheet(questionnaire!);
  }
}