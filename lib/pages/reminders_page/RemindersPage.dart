import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/reminders_page/RemindersActions.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../widgets/TextDandyLight.dart';
import 'ReminderListWidget.dart';

class RemindersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RemindersPageState();
  }
}

class _RemindersPageState extends State<RemindersPage> with TickerProviderStateMixin {
  ScrollController? _scrollController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, RemindersPageState>(
        onInit: (store) {
          store.dispatch(FetchRemindersAction(store.state.remindersPageState));
        },
        converter: (Store<AppState> store) => RemindersPageState.fromStore(store),
        builder: (BuildContext context, RemindersPageState pageState) =>
            Scaffold(
              body: Container(
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
                      centerTitle: true,
                      elevation: 0.0,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Reminders",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            UserOptionsUtil.showNewReminderDialog(context, null);
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
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          pageState.reminders!.length > 0 ? ListView.builder(
                            reverse: false,
                            padding: new EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 64.0),
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            key: _listKey,
                            itemCount: pageState.reminders!.length,
                            itemBuilder: _buildItem,
                          ) :
                          Padding(
                            padding: EdgeInsets.only(left: 64.0, top: 48.0, right: 64.0),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: "You have not created any reminders yet. To create a new reminder, select the plus icon.",
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
            ),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, RemindersPageState>(
      converter: (store) => RemindersPageState.fromStore(store),
      builder: (BuildContext context, RemindersPageState pageState) =>
          Container(
            margin: EdgeInsets.only(top: 0.0, bottom: 8.0),
            child: ReminderListWidget(pageState.reminders!.elementAt(index), pageState, onReminderSelected, Color(ColorConstants.getBlueLight()), Color(ColorConstants.getPrimaryBlack())),
          ),
    );
  }

  onReminderSelected(ReminderDandyLight reminder, RemindersPageState pageState,  BuildContext context) {
    pageState.onReminderSelected!(reminder);
    UserOptionsUtil.showNewReminderDialog(context, reminder);
  }
}
