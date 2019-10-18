import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:redux/redux.dart';

class ClientDetailsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is InitializeClientDetailsAction){
      initializedClientDetailsState(store, next, action);
    }
  }

  void initializedClientDetailsState(Store<AppState> store, NextDispatcher next, InitializeClientDetailsAction action) {
      next(InitializeClientDetailsAction(store.state.clientDetailsPageState, action.client));
  }
}