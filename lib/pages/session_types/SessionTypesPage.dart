import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/SessionType.dart';
import '../../widgets/TextDandyLight.dart';
import 'SessionTypesActions.dart';
import 'SessionTypesListWidget.dart';
import 'SessionTypesPageState.dart';

class SessionTypesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SessionTypesPageState();
  }
}

class _SessionTypesPageState extends State<SessionTypesPage> with TickerProviderStateMixin {
  ScrollController? _scrollController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, SessionTypesPageState>(
        onInit: (store) {
          store.dispatch(FetchSessionTypesAction(store.state.sessionTypesPageState));
        },
        converter: (Store<AppState> store) => SessionTypesPageState.fromStore(store),
        builder: (BuildContext context, SessionTypesPageState pageState) =>
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      iconTheme: IconThemeData(
                        color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                      ),
                      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0.0,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Session Types",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            NavigationUtil.showNewSessionTypePage(context, null);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 26.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPrimaryBlack()),),
                          ),
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          pageState.sessionTypes!.isNotEmpty ? ListView.builder(
                            reverse: false,
                            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 64.0),
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            key: _listKey,
                            itemCount: pageState.sessionTypes!.length,
                            itemBuilder: _buildItem,
                          ) :
                          Padding(
                            padding: const EdgeInsets.only(left: 48.0, top: 48.0, right: 48.0),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: "Create your own session types here to help save time managing and booking your jobs.\n\n(Wedding, Engagement, Family, etc...)",
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
    return StoreConnector<AppState, SessionTypesPageState>(
      converter: (store) => SessionTypesPageState.fromStore(store),
      builder: (BuildContext context, SessionTypesPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(top: 0.0, bottom: 8.0),
            child: SessionTypesListWidget(pageState.sessionTypes!.elementAt(index), pageState, onSessionTypeSelected, Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5), Color(ColorConstants.getPrimaryBlack()), index),
          ),
    );
  }

  onSessionTypeSelected(SessionType sessionType, SessionTypesPageState pageState,  BuildContext context) {
    NavigationUtil.showNewSessionTypePage(context, sessionType);
  }
}
