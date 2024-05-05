import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../models/Questionnaire.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/styles/Styles.dart';
import '../../../widgets/TextDandyLight.dart';
import '../DashboardPageState.dart';


class QuestionnairesDashboardPage extends StatefulWidget {
  const QuestionnairesDashboardPage(this.selectorIndex, {Key? key}) : super(key: key);

  static const String FILTER_TYPE_NOT_COMPLETED = "Incomplete";
  static const String FILTER_TYPE_COMPETED = "Complete";
  static const String FILTER_TYPE_ALL = "All";
  final int selectorIndex;

  @override
  State<StatefulWidget> createState() {
    return _QuestionnairesDashboardPageState(selectorIndex);
  }
}

class _QuestionnairesDashboardPageState extends State<QuestionnairesDashboardPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  int? selectorIndex;
  Map<int, Widget>? type;

  _QuestionnairesDashboardPageState(this.selectorIndex);

  @override
  Widget build(BuildContext context) {
    type = <int, Widget>{
      0: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: QuestionnairesDashboardPage.FILTER_TYPE_NOT_COMPLETED,
        color: Color(selectorIndex == 0
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      1: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: QuestionnairesDashboardPage.FILTER_TYPE_COMPETED,
        color: Color(selectorIndex == 1
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      2: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: QuestionnairesDashboardPage.FILTER_TYPE_ALL,
        color: Color(selectorIndex == 2
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
    };
    return StoreConnector<AppState, DashboardPageState>(
        converter: (store) => DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(
                          color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                        ),
                        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                        pinned: true,
                        centerTitle: true,
                        title: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: "Questionnaires",
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(44.0),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              thumbColor: Color(ColorConstants.getBlueLight()),
                              children: type!,
                              onValueChanged: (int? filterTypeIndex) {
                                setState(() {
                                  selectorIndex = filterTypeIndex;
                                });
                              },
                              groupValue: selectorIndex,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            ListView.builder(
                              reverse: false,
                              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: const ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: selectorIndex == 0 ? (pageState.notCompleteQuestionnaires?.length ?? 0) : selectorIndex == 1 ? (pageState.completedQuestionnaires?.length ?? 0) : (pageState.allQuestionnaires?.length ?? 0),
                              itemBuilder: (context, index) {
                                return TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () async {
                                    UserOptionsUtil.showQuestionnaireOptionsSheet(context, getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index), openQuestionnaireEditPage, pageState.profile!, pageState.markQuestionnaireAsReviewed!);
                                  },
                                  child: SizedBox(
                                    height: 54.0,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(right: 12.0),
                                              height: 42.0,
                                              width: 42.0,
                                              child: Image.asset(
                                                  'assets/images/collection_icons/questionaire_icon_white.png',
                                                  color: selectorIndex == 1 ? (getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).isReviewed ?? false) ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPeachDark()) : Color(ColorConstants.getPeachDark()),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width-164,
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.MEDIUM_TEXT,
                                                      overflow: TextOverflow.ellipsis,
                                                      text: getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).title,
                                                      color: selectorIndex == 1 ? (getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).isReviewed ?? false) ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBlack()),
                                                    ),
                                                  ),
                                                  TextDandyLight(
                                                    type: TextDandyLight.SMALL_TEXT,
                                                    text: selectorIndex == 1 ? 'Completed: ${TextFormatterUtil.formatDateStandard((getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).dateCompleted) ?? DateTime.now())}' : 'Created: ${TextFormatterUtil.formatDateStandard((getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).dateCreated) ?? DateTime.now())}',
                                                    color: selectorIndex == 1 ? (getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).isReviewed ?? false) ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBlack()),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 36,
                                          margin: const EdgeInsets.only(right: 16),
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
          ),
        ),
      );
  }

  List<Questionnaire> getListBasedOnSelectorIndex(int? index, DashboardPageState pageState) {
    List<Questionnaire> result = [];
    switch(index) {
      case 0:
        result = pageState.notCompleteQuestionnaires!;
        break;
      case 1:
        result = pageState.completedQuestionnaires!;
        break;
      case 2:
        result = pageState.allQuestionnaires!;
        break;
    }
    return result;
  }

  void openQuestionnaireEditPage(BuildContext context, Questionnaire questionnaire) {
    NavigationUtil.onQuestionnaireSelected(context, questionnaire, questionnaire.title ?? '', false, questionnaire.jobDocumentId, _ackQuestionnaireAlert);
  }

  Future<void> _ackQuestionnaireAlert(BuildContext context, Questionnaire questionnaire) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This questionnaire will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                // pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This questionnaire will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                // pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
