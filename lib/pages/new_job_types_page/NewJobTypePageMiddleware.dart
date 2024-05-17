import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/job_types/JobTypesActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import '../../models/Profile.dart';
import '../../models/Progress.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../dashboard_page/DashboardPageActions.dart';
import '../new_job_page/NewJobPageActions.dart';
import 'NewJobTypeActions.dart';

class NewJobTypePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveNewJobTypeAction){
      saveNewJobType(store, action, next);
    }
    if(action is DeleteJobTypeAction){
      _deleteJobType(store, action, next);
    }
    if(action is LoadPricesPackagesAndRemindersAction) {
      _load(store, action, next);
    }
  }

  void _load(Store<AppState> store, LoadPricesPackagesAndRemindersAction action, NextDispatcher next) async{
    List<ReminderDandyLight> allReminders = await ReminderDao.getAll();
    store.dispatch(SetAllAction(store.state.newJobTypePageState, allReminders));
  }

  void saveNewJobType(Store<AppState> store, SaveNewJobTypeAction action, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    List<JobStage>? stages = store.state.newJobTypePageState!.selectedJobStages;

    stages!.insert(0, JobStage(id: 1, stage: JobStage.STAGE_1_INQUIRY_RECEIVED, imageLocation: JobStage.getImageLocation(JobStage.STAGE_1_INQUIRY_RECEIVED)));
    stages!.add(JobStage(id: 14, stage: JobStage.STAGE_14_JOB_COMPLETE, imageLocation: JobStage.getImageLocation(JobStage.STAGE_14_JOB_COMPLETE)));
    JobType newJobType = JobType(
      id: store.state.newJobTypePageState!.id,
      documentId: store.state.newJobTypePageState!.documentId,
      title: store.state.newJobTypePageState!.title,
      createdDate: DateTime.now(),
      stages: stages,
      reminders: store.state.newJobTypePageState!.selectedReminders,
    );

    await JobTypeDao.insertOrUpdate(newJobType);

    EventSender().sendEvent(eventName: EventNames.CREATED_JOB_TYPE, properties: {
      EventNames.JOB_TYPE_PARAM_NAME : newJobType.title!,
      EventNames.JOB_TYPE_PARAM_REMINDER_NAMES : newJobType.reminders!.map((reminder) => reminder.description).toList(),
      EventNames.JOB_TYPE_PARAM_STAGE_NAMES : newJobType.stages!.map((stage) => stage.stage).toList(),
    });

    store.dispatch(FetchJobTypesAction(store.state.jobTypesPageState));

    JobType jobTypeWithDocumentId = await JobTypeDao.getByName(newJobType.title!);
    store.dispatch(UpdateWithNewJobTypeAction(store.state.newJobPageState, jobTypeWithDocumentId));

    if(profile != null && profile.progress.createJobType) {
      profile.progress.createJobType = true;
      await ProfileDao.update(profile);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
      EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
        EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.CREATE_JOB_TYPE,
      });
    }
  }

  void _deleteJobType(Store<AppState> store, DeleteJobTypeAction action, NextDispatcher next) async{
    await JobTypeDao.delete(store.state.newJobTypePageState!.documentId!);
    JobType? jobType = await JobTypeDao.getJobTypeById(action.pageState!.documentId!);
    if(jobType != null) {
      await JobTypeDao.delete(action.pageState!.documentId!);
    }

    store.dispatch(FetchJobTypesAction(store.state.jobTypesPageState));
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