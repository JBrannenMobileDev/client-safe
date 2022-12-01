
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseGroupDao.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../poses_page/PosesActions.dart';
import 'NewPoseGroupActions.dart';

class NewPoseGroupPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveAction){
      _save(store, action, next);
    }
  }

  void _save(Store<AppState> store, SaveAction action, NextDispatcher next) async{
    PoseGroup poseGroup = PoseGroup();
    poseGroup.id = action.pageState.id;
    poseGroup.documentId = action.pageState.documentId;
    poseGroup.groupName = action.pageState.groupName;

    await PoseGroupDao.insertOrUpdate(poseGroup);

    EventSender().sendEvent(eventName: EventNames.CREATED_POSE_GROUP, properties: {EventNames.POSE_GROUP_PARAM_NAME : poseGroup.groupName,});

    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
  }
}