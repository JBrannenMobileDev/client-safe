import 'package:dandylight/pages/poses_page/widgets/PoseGroupListWidget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../AppState.dart';
import '../../models/Job.dart';
import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';
import 'PosesPageState.dart';

class MyPosesPage extends StatefulWidget {
  final Job job;

  MyPosesPage(this.job);

  @override
  State<StatefulWidget> createState() {
    return _MyPosesPageState(job);
  }
}

class _MyPosesPageState extends State<MyPosesPage> {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Job job;

  _MyPosesPageState(this.job);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (Store<AppState> store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
      pageState.poseGroups.length > 0 ? Container(
        height: (MediaQuery
            .of(context)
            .size
            .height),
        child: ListView.builder(
            padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 250.0),
            itemCount: pageState.poseGroups.length,
            controller: _controller,
            physics: AlwaysScrollableScrollPhysics(),
            key: _listKey,
            shrinkWrap: true,
            reverse: false,
            itemBuilder: _buildItem
        ),
      ) :
      Padding(
        padding: EdgeInsets.only(
            left: 32.0, top: 48.0, right: 32.0),
        child: TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: "Save your poses here. \nSelect the plus icon to create a new collection.",
          textAlign: TextAlign.center,
          color: Color(ColorConstants.getPeachDark()),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          PoseGroupListWidget(index, job),
    );
  }
}