import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/SessionTypeDao.dart';
import 'package:dandylight/models/SessionType.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import 'SessionTypesActions.dart';

class SessionTypesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchSessionTypesAction){
      fetchJobTypes(store, next);
    }
  }

  void fetchJobTypes(Store<AppState> store, NextDispatcher next) async{
      List<SessionType>? sessionTypes = await SessionTypeDao.getAll();
      next(SetSessionTypesAction(store.state.sessionTypesPageState, sessionTypes));

      (await SessionTypeDao.getSessionTypeStream()).listen((snapshots) async {
        List<SessionType> sessionTypesToUpdate = [];
        for(RecordSnapshot sessionTypesSnapshot in snapshots) {
          sessionTypesToUpdate.add(SessionType.fromMap(sessionTypesSnapshot.value! as Map<String,dynamic>));
        }
        store.dispatch(SetSessionTypesAction(store.state.sessionTypesPageState, sessionTypesToUpdate));
      });
  }
}