
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseGroupDao.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:redux/redux.dart';

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

    PoseGroup group = await PoseGroupDao.insertOrUpdate(poseGroup);
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
  }
}