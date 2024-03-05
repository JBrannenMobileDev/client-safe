
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import 'AnswerQuestionnaireActions.dart';

class AnswerQuestionnairePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchProfileForAnswerAction) {
      fetchProfile(store, action, next);
    }
    if(action is SaveShortFormAnswerAction) {
      saveShortFormAnswer(store, action, next);
    }
  }
  void saveShortFormAnswer(Store<AppState> store, SaveShortFormAnswerAction action, NextDispatcher next) async{
    //TODO this !! save short form answer to question and questionnaire then save updated questionnaire to pageState
  }

  void fetchProfile(Store<AppState> store, FetchProfileForAnswerAction action, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    next(SetProfileForAnswerAction(store.state.answerQuestionnairePageState, profile));
  }
}