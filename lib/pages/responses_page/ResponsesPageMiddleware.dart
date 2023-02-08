import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ResponseDao.dart';
import 'package:dandylight/pages/responses_page/ResponsesActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import '../../models/Response.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../client_details_page/ClientDetailsPageActions.dart';

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
    if(await ResponseDao.getResponseById(action.item.response.documentId) != null) {
      await ResponseDao.delete(action.item.response.documentId);
    }
    fetchResponses(store);
    store.dispatch(FetchClientDetailsResponsesAction(store.state.clientDetailsPageState));
  }

  void updateResponse(Store<AppState> store, UpdateResponseAction action) async{
    await ResponseDao.insertOrUpdate(action.responseItem.response);
    fetchResponses(store);
    store.dispatch(FetchClientDetailsResponsesAction(store.state.clientDetailsPageState));
  }

  void saveNewResponse(Store<AppState> store, SaveNewResponseAction action, ) async{
    await ResponseDao.insertOrUpdate(action.response);
    fetchResponses(store);
    store.dispatch(FetchClientDetailsResponsesAction(store.state.clientDetailsPageState));
    EventSender().sendEvent(eventName: EventNames.CREATED_RESPONSE);
  }

  void fetchResponses(Store<AppState> store) async{
    List<Response> responses = await ResponseDao.getAll();
    store.dispatch(SetResponsesAction(store.state.responsesPageState, responses));
  }
}