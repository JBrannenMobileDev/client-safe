import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ResponseDao.dart';
import 'package:dandylight/pages/responses_page/ResponsesActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import '../../models/Response.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';

class ResponsesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchResponsesAction){
      fetchResponses(store);
    }
    if(action is UpdateResponseAction) {
      updateResponse(store, action);
    }
    if(action is SaveNewResponseAction) {
      saveNewResponse(store, action);
    }
    if(action is DeleteResponseAction) {
      deleteResponse(store, action);
    }
  }

  void deleteResponse(Store<AppState> store, DeleteResponseAction action) async{
    await ResponseDao.delete(action.item.response.documentId);
    fetchResponses(store);
  }

  void updateResponse(Store<AppState> store, UpdateResponseAction action) async{
    await ResponseDao.insertOrUpdate(action.responseItem.response);
  }

  void saveNewResponse(Store<AppState> store, SaveNewResponseAction action, ) async{
    await ResponseDao.insertOrUpdate(action.response);
    fetchResponses(store);
    EventSender().sendEvent(eventName: EventNames.CREATED_RESPONSE);
  }

  void fetchResponses(Store<AppState> store) async{
    List<Response> responses = await ResponseDao.getAll();
    store.dispatch(SetResponsesAction(store.state.responsesPageState, responses));

    (await ResponseDao.getResponseStream()).listen((snapshots) async {
      List<Response> streamResponses = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamResponses.add(Response.fromMap(clientSnapshot.value));
      }

      store.dispatch(SetResponsesAction(store.state.responsesPageState, responses));
    });
  }
}