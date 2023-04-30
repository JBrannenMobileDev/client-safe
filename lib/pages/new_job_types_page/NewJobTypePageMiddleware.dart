import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/job_types/JobTypesActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
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
    List<JobStage> unorderedSelectedStages = store.state.newJobTypePageState.selectedJobStages;
    List<JobStage> allStagesOrdered = store.state.newJobTypePageState.allJobStages;
    List<JobStage> selectedStages = [];

    allStagesOrdered.forEach((orderedStage) {
      if(stageListContainsStage(unorderedSelectedStages, orderedStage)){
        selectedStages.add(orderedStage);
      }
    });test this stage logic

    selectedStages.insert(0, JobStage(id: 1, stage: JobStage.STAGE_1_INQUIRY_RECEIVED, imageLocation: JobStage.getImageLocation(JobStage.STAGE_1_INQUIRY_RECEIVED)));
    selectedStages.add(JobStage(id: 14, stage: JobStage.STAGE_14_JOB_COMPLETE, imageLocation: JobStage.getImageLocation(JobStage.STAGE_14_JOB_COMPLETE)));
    JobType newJobType = JobType(
      id: store.state.newJobTypePageState.id,
      documentId: store.state.newJobTypePageState.documentId,
      title: store.state.newJobTypePageState.title,
      createdDate: DateTime.now(),
      stages: selectedStages,
      reminders: store.state.newJobTypePageState.selectedReminders,
    );

    await JobTypeDao.insertOrUpdate(newJobType);

    EventSender().sendEvent(eventName: EventNames.CREATED_JOB_TYPE, properties: {
      EventNames.JOB_TYPE_PARAM_NAME : newJobType.title,
      EventNames.JOB_TYPE_PARAM_REMINDER_NAMES : newJobType.reminders.map((reminder) => reminder.description).toList(),
      EventNames.JOB_TYPE_PARAM_STAGE_NAMES : newJobType.stages.map((stage) => stage.stage).toList(),
    });

    store.dispatch(FetchJobTypesAction(store.state.jobTypesPageState));

    JobType jobTypeWithDocumentId = await JobTypeDao.getByName(newJobType.title);
    store.dispatch(UpdateWithNewJobTypeAction(store.state.newJobPageState, jobTypeWithDocumentId));
  }

  void _deleteJobType(Store<AppState> store, DeleteJobTypeAction action, NextDispatcher next) async{
    await JobTypeDao.delete(store.state.newJobTypePageState.documentId);
    JobType jobType = await JobTypeDao.getJobTypeById(action.pageState.documentId);
    if(jobType != null) {
      await JobTypeDao.delete(action.pageState.documentId);
    }

    store.dispatch(FetchJobTypesAction(store.state.jobTypesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  bool stageListContainsStage(List<JobStage> unorderedSelectedStages, JobStage orderedStage) {
    unorderedSelectedStages.forEach((unorderedStage) {
      if(unorderedStage.stage == orderedStage.stage) return true;
    });
    return false;
  }
}