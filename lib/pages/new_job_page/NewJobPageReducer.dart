import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:redux/redux.dart';
import 'NewJobPageState.dart';

final newJobPageReducer = combineReducers<NewJobPageState>([
  TypedReducer<NewJobPageState, ClearStateAction>(_clearState),
  TypedReducer<NewJobPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewJobPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewJobPageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewJobPageState, SetAllClientsToStateAction>(_setAllClients),
]);

NewJobPageState _updateErrorState(NewJobPageState previousState, UpdateErrorStateAction action){
  return previousState.copyWith(
      errorState: action.errorCode
  );
}

NewJobPageState _incrementPageViewIndex(NewJobPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewJobPageState _decrementPageViewIndex(NewJobPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewJobPageState _clearState(NewJobPageState previousState, ClearStateAction action) {
  return NewJobPageState.initial();
}

NewJobPageState _setAllClients(NewJobPageState previousState, SetAllClientsToStateAction action) {
  return previousState.copyWith(
    allClients: action.allClients,
  );
}