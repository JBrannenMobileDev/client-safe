import 'package:dandylight/AppState.dart';
import 'package:redux/redux.dart';

import 'ContractEditActions.dart';

class ContractsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveContractAction){
      saveContract(store, next);
    }
  }

  void saveContract(Store<AppState> store, NextDispatcher next) async{

  }
}