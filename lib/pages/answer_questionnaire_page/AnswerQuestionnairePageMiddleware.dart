
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
    if(action is SaveLongFormAnswerAction) {
      saveLongFormAnswer(store, action, next);
    }
    if(action is SaveFirstNameAnswerAction) {
      saveFirstNameAnswer(store, action, next);
    }
    if(action is SaveLastNameAnswerAction) {
      saveLastNameAnswer(store, action, next);
    }
    if(action is SavePhoneNumberAnswerAction) {
      savePhoneNumberAnswer(store, action, next);
    }
    if(action is SaveEmailAnswerAction) {
      saveEmailAnswer(store, action, next);
    }
    if(action is SaveInstagramNameAnswerAction) {
      saveInstagramNameAnswer(store, action, next);
    }
    if(action is SaveNumberAnswerAction) {
      saveNumberAnswer(store, action, next);
    }
    if(action is SaveYesNoAnswerAction) {
      saveYesNoAnswer(store, action, next);
    }
    if(action is SaveCheckBoxSelectionAction) {
      saveCheckBoxSelectionAnswer(store, action, next);
    }
    if(action is SaveRatingSelectionAction) {
      saveRatingSelectionAnswer(store, action, next);
    }
    if(action is SaveDateSelectionAction) {
      saveDateSelectionAnswer(store, action, next);
    }
    if(action is SaveAddressAnswerAction) {
      saveAddressAnswer(store, action, next);
    }
    if(action is SaveAddressLine2AnswerAction) {
      saveAddressLine2Answer(store, action, next);
    }
    if(action is SaveCityTownAnswerAction) {
      saveCityTownAnswer(store, action, next);
    }
    if(action is SaveStateRegionAnswerAction) {
      saveStateRegionAnswer(store, action, next);
    }
    if(action is SaveZipAnswerAction) {
      saveZipAnswer(store, action, next);
    }
    if(action is SaveCountryAnswerAction) {
      saveCountryAnswer(store, action, next);
    }
  }

  void saveAddressAnswer(Store<AppState> store, SaveAddressAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.address = action.answer;
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

  void saveAddressLine2Answer(Store<AppState> store, SaveAddressLine2AnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.addressLine2 = action.answer;
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

  void saveCityTownAnswer(Store<AppState> store, SaveCityTownAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.cityTown = action.answer;
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

  void saveStateRegionAnswer(Store<AppState> store, SaveStateRegionAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.stateRegionProvince = action.answer;
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

  void saveZipAnswer(Store<AppState> store, SaveZipAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.zipPostCode = action.answer;
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

  void saveCountryAnswer(Store<AppState> store, SaveCountryAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.country = action.answer;
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

  void saveDateSelectionAnswer(Store<AppState> store, SaveDateSelectionAction action, NextDispatcher next) async{
    Question question = action.question;
    question.month = action.date?.month ?? DateTime.now().month;
    question.day = action.date?.day ?? DateTime.now().day;
    question.year = action.date?.year ?? DateTime.now().year;
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

  void saveRatingSelectionAnswer(Store<AppState> store, SaveRatingSelectionAction action, NextDispatcher next) async{
    Question question = action.question;
    question.ratingAnswer = action.selectedRating;
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

  void saveCheckBoxSelectionAnswer(Store<AppState> store, SaveCheckBoxSelectionAction action, NextDispatcher next) async{
    Question question = action.question;
    List selectedCheckBoxes = action.question.answersCheckBoxes ?? [];

    if(selectedCheckBoxes.contains(question.choicesCheckBoxes?.elementAt(action.selectedIndex))) {
      selectedCheckBoxes.removeWhere((item) => item == question.choicesCheckBoxes?.elementAt(action.selectedIndex));
    } else {
      selectedCheckBoxes.add(question.choicesCheckBoxes?.elementAt(action.selectedIndex));
    }

    question.answersCheckBoxes =selectedCheckBoxes;

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

  void saveYesNoAnswer(Store<AppState> store, SaveYesNoAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.yesSelected = action.answer;
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

  void saveNumberAnswer(Store<AppState> store, SaveNumberAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.number = int.parse(action.answer);
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

  void saveLongFormAnswer(Store<AppState> store, SaveLongFormAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.longAnswer = action.answer;
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

  void saveFirstNameAnswer(Store<AppState> store, SaveFirstNameAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.firstName = action.answer;
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

  void saveLastNameAnswer(Store<AppState> store, SaveLastNameAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.lastName = action.answer;
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

  void savePhoneNumberAnswer(Store<AppState> store, SavePhoneNumberAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.phone = action.answer;
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

  void saveEmailAnswer(Store<AppState> store, SaveEmailAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.email = action.answer;
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

  void saveInstagramNameAnswer(Store<AppState> store, SaveInstagramNameAnswerAction action, NextDispatcher next) async{
    Question question = action.question;
    question.instagramName = action.answer;
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
    Questionnaire questionnaire = action.questionnaire;
    await store.dispatch(ClearAnswerState(store.state.answerQuestionnairePageState!));
    store.dispatch(SetQuestionnaireAction(store.state.answerQuestionnairePageState!, questionnaire));
    store.dispatch(SetProfileForAnswerAction(store.state.answerQuestionnairePageState!, profile!));
  }
}