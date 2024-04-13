import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pose_group_page/NewPoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';
import 'NewPoseGroupTextField.dart';


class NewPoseGroupName extends StatefulWidget {
  @override
  _NewPoseGroupName createState() {
    return _NewPoseGroupName();
  }
}

class _NewPoseGroupName extends State<NewPoseGroupName> with AutomaticKeepAliveClientMixin {
  final contractNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewPoseGroupPageState>(
      onInit: (store) {
        contractNameTextController.text = store.state.newPoseGroupPageState!.groupName!;
      },
      converter: (store) => NewPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, NewPoseGroupPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "Enter a simple and descriptive name for this pose collection. ",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            NewPoseGroupTextField(
                contractNameTextController,
                "Collection Name",
                TextInputType.text,
                64.0,
                pageState.onNameChanged,
                'Collection name is required',
                TextInputAction.done,
                null,
                null,
                TextCapitalization.words,
                null),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
