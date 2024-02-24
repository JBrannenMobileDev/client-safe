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


class QuestionnairesPage extends StatefulWidget {
  const QuestionnairesPage(this.selectorIndex, {Key key}) : super(key: key);

  static const String FILTER_TYPE_NOT_COMPLETED = "Incomplete";
  static const String FILTER_TYPE_COMPETED = "Complete";
  static const String FILTER_TYPE_ALL = "All";
  final int selectorIndex;

  @override
  State<StatefulWidget> createState() {
    return _QuestionnairesPageState(selectorIndex);
  }
}

class _QuestionnairesPageState extends State<QuestionnairesPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  int selectorIndex;
  Map<int, Widget> type;

  _QuestionnairesPageState(this.selectorIndex);

  @override
  Widget build(BuildContext context) {
    type = <int, Widget>{
      0: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: QuestionnairesPage.FILTER_TYPE_NOT_COMPLETED,
        color: Color(selectorIndex == 0
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      1: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: QuestionnairesPage.FILTER_TYPE_COMPETED,
        color: Color(selectorIndex == 1
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      2: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: QuestionnairesPage.FILTER_TYPE_ALL,
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
                        brightness: Brightness.light,
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
                              children: type,
                              onValueChanged: (int filterTypeIndex) {
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
                              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: const ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: selectorIndex == 0 ? pageState.notCompleteQuestionnaires.length : selectorIndex == 1 ? pageState.completedQuestionnaires.length : pageState.allQuestionnaires.length,
                              itemBuilder: (context, index) {
                                return TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () async {
                                    UserOptionsUtil.showQuestionnaireOptionsSheet(context, getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index), openQuestionnaireEditPage);
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
                                              child: Image.asset('assets/images/collection_icons/questionaire_icon_white.png', color: Color(ColorConstants.getPeachDark())),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextDandyLight(
                                                      type: TextDandyLight.MEDIUM_TEXT,
                                                      text: getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).title,
                                                  ),
                                                  TextDandyLight(
                                                    type: TextDandyLight.SMALL_TEXT,
                                                    text: 'Created: ${TextFormatterUtil.formatDateStandard((getListBasedOnSelectorIndex(selectorIndex, pageState).elementAt(index).dateCreated) ?? DateTime.now())}',
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

  List<Questionnaire> getListBasedOnSelectorIndex(int index, DashboardPageState pageState) {
    List<Questionnaire> result = [];
    switch(index) {
      case 0:
        result = pageState.notCompleteQuestionnaires;
        break;
      case 1:
        result = pageState.completedQuestionnaires;
        break;
      case 2:
        result = pageState.allQuestionnaires;
        break;
    }
    return result;
  }

  void openQuestionnaireEditPage(BuildContext context, Questionnaire questionnaire) {
    NavigationUtil.onQuestionnaireSelected(context, questionnaire, questionnaire.title, false, questionnaire.jobDocumentId, _ackQuestionnaireAlert);
  }

  Future<void> _ackQuestionnaireAlert(BuildContext context) {
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
