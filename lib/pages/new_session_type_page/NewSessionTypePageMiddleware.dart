import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SessionTypeDao.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/models/SessionType.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import '../../models/Profile.dart';
import '../../models/Progress.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../booking_page/BookingPageActions.dart';
import '../dashboard_page/DashboardPageActions.dart';
import '../new_job_page/NewJobPageActions.dart';
import '../session_types/SessionTypesActions.dart';
import 'NewSessionTypeActions.dart';

class NewSessionTypePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveNewSessionTypeAction){
      saveNewSessionType(store, action, next);
    }
    if(action is DeleteSessionTypeAction){
      _deleteJobType(store, action, next);
    }
    if(action is LoadAllRemindersAction) {
      _load(store, action, next);
    }
  }

  void _load(Store<AppState> store, LoadAllRemindersAction action, NextDispatcher next) async{
    List<ReminderDandyLight> allReminders = await ReminderDao.getAll();
    store.dispatch(SetAllAction(store.state.newSessionTypePageState, allReminders));
  }

  void saveNewSessionType(Store<AppState> store, SaveNewSessionTypeAction action, NextDispatcher next) async{
    List<JobStage>? stages = store.state.newSessionTypePageState!.selectedJobStages;

    stages!.insert(0, JobStage(id: 1, stage: JobStage.STAGE_1_INQUIRY_RECEIVED, imageLocation: JobStage.getImageLocation(JobStage.STAGE_1_INQUIRY_RECEIVED)));
    stages.add(JobStage(id: 14, stage: JobStage.STAGE_14_JOB_COMPLETE, imageLocation: JobStage.getImageLocation(JobStage.STAGE_14_JOB_COMPLETE)));

    SessionType newSessionType = SessionType(
      id: store.state.newSessionTypePageState!.id,
      documentId: store.state.newSessionTypePageState!.documentId,
      title: store.state.newSessionTypePageState!.title ?? 'No title',
      createdDate: DateTime.now(),
      stages: stages,
      reminders: store.state.newSessionTypePageState?.selectedReminders ?? [],
      durationMinutes: store.state.newSessionTypePageState?.minutes ?? 0,
      durationHours: store.state.newSessionTypePageState?.hours ?? 0,
      totalCost: store.state.newSessionTypePageState?.totalCost ?? 0.0,
      deposit: store.state.newSessionTypePageState?.deposit ?? 0.0,
      salesTaxPercent: store.state.newSessionTypePageState?.taxPercent ?? 0.0,
    );

    await SessionTypeDao.insertOrUpdate(newSessionType);

    EventSender().sendEvent(eventName: EventNames.CREATED_JOB_TYPE, properties: {
      EventNames.JOB_TYPE_PARAM_NAME : newSessionType.title,
      EventNames.JOB_TYPE_PARAM_REMINDER_NAMES : newSessionType.reminders.map((reminder) => reminder.description).toList(),
      EventNames.JOB_TYPE_PARAM_STAGE_NAMES : newSessionType.stages.map((stage) => stage.stage).toList(),
    });

    store.dispatch(FetchSessionTypesAction(store.state.sessionTypesPageState));

    SessionType sessionTypeWithDocumentId = await SessionTypeDao.getByName(newSessionType.title);
    store.dispatch(UpdateWithNewSessionTypeAction(store.state.newJobPageState, sessionTypeWithDocumentId));
    store.dispatch(UpdateBookingPageWithNewSessionTypeAction(store.state.bookingPageState, sessionTypeWithDocumentId));

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null && !profile.progress.createSessionType) {
      profile.progress.createSessionType = true;
      await ProfileDao.update(profile);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
      EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
        EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.CREATE_SESSION_TYPE,
      });
    }
  }

  void _deleteJobType(Store<AppState> store, DeleteSessionTypeAction action, NextDispatcher next) async{
    await SessionTypeDao.delete(store.state.newSessionTypePageState!.documentId!);
    SessionType? sessionType = await SessionTypeDao.getSessionTypeById(action.pageState!.documentId!);
    if(sessionType != null) {
      await SessionTypeDao.delete(action.pageState!.documentId!);
    }

    store.dispatch(FetchSessionTypesAction(store.state.sessionTypesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState!.pop();
  }

  bool stageListContainsStage(List<JobStage> unorderedSelectedStages, JobStage orderedStage) {
    bool result = false;
    unorderedSelectedStages.forEach((unorderedStage) {
      if(unorderedStage.stage == orderedStage.stage) result = true;
    });
    return result;
  }
}