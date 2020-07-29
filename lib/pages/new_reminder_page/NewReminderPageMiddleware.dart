import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:redux/redux.dart';

class NewReminderPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveNewReminderAction){
      saveReminder(store, action, next);
    }
    if(action is DeleteReminderAction){
      _deleteReminder(store, action, next);
    }
  }

  void saveReminder(Store<AppState> store, SaveNewReminderAction action, NextDispatcher next) async{

  }

  void _deleteReminder(Store<AppState> store, DeleteReminderAction action, NextDispatcher next) async{

  }
}