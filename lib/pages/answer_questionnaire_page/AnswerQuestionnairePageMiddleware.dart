
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import '../../models/Question.dart';
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
    Question question = action.question;
    question.shortAnswer = action.answer;
    List<Question> questions = action.pageState.questionnaire!.questions ?? [];

    for (final (index, loopQuestion) in questions.indexed) {
      if(question.id == loopQuestion.id) {
        questions[index] = question;
      }
    }

    Questionnaire questionnaire = action.pageState.questionnaire!;
    questionnaire.questions = questions;
    store.dispatch(SetQuestionnaireAction(action.pageState, questionnaire));
  }

  void fetchProfile(Store<AppState> store, FetchProfileForAnswerAction action, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetQuestionnaireAction(store.state.answerQuestionnairePageState!, action.questionnaire));
    store.dispatch(SetProfileForAnswerAction(store.state.answerQuestionnairePageState!, profile!));
  }
}