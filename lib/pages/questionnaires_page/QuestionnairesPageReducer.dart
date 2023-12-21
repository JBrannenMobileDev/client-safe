import 'package:dandylight/pages/questionnaires_page/QuestionnairesPageState.dart';
import 'package:redux/redux.dart';

import 'QuestionnairesActions.dart';

final questionnairesReducer = combineReducers<QuestionnairesPageState>([
  TypedReducer<QuestionnairesPageState, SetContractsAction>(_setContracts),
]);

QuestionnairesPageState _setContracts(QuestionnairesPageState previousState, SetContractsAction action){
  return previousState.copyWith(
    contracts: action.contracts,
    contractTemplates: action.contractTemplates,
  );
}
