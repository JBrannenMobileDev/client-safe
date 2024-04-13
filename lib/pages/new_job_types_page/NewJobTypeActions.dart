

import 'package:dandylight/models/ReminderDandyLight.dart';
import '../../models/JobStage.dart';
import '../../models/JobType.dart';
import 'NewJobTypePageState.dart';

class LoadExistingJobTypeData{
  final NewJobTypePageState? pageState;
  final JobType? jobType;
  LoadExistingJobTypeData(this.pageState, this.jobType);
}

class LoadPricesPackagesAndRemindersAction {
  final NewJobTypePageState? pageState;
  LoadPricesPackagesAndRemindersAction(this.pageState);
}

class SetAllAction {
  final NewJobTypePageState? pageState;
  final List<ReminderDandyLight>? allReminders;
  SetAllAction(this.pageState, this.allReminders);
}

class SaveNewJobTypeAction{
  final NewJobTypePageState? pageState;
  SaveNewJobTypeAction(this.pageState);
}

class DeleteJobTypeAction{
  final NewJobTypePageState? pageState;
  DeleteJobTypeAction(this.pageState);
}

class ClearNewJobTypeStateAction{
  final NewJobTypePageState? pageState;
  ClearNewJobTypeStateAction(this.pageState);
}

class UpdateJobTypeTitleAction{
  final NewJobTypePageState? pageState;
  final String? title;
  UpdateJobTypeTitleAction(this.pageState, this.title);
}

class UpdateSelectedReminderListAction{
  final NewJobTypePageState? pageState;
  final int? reminderStageIndex;
  final bool? isChecked;
  UpdateSelectedReminderListAction(this.pageState, this.reminderStageIndex, this.isChecked);
}

class DeleteJobStageAction{
  final NewJobTypePageState? pageState;
  final int? jobStageIndex;
  DeleteJobStageAction(this.pageState, this.jobStageIndex);
}

class UpdateCheckAllRemindersAction {
  final NewJobTypePageState? pageState;
  final bool? isChecked;
  UpdateCheckAllRemindersAction(this.pageState, this.isChecked);
}

class SaveSelectedRateTypeAction{
  final NewJobTypePageState? pageState;
  final String? rateType;
  SaveSelectedRateTypeAction(this.pageState, this.rateType);
}

class UpdateStageListAction{
  final NewJobTypePageState? pageState;
  final List<JobStage>? stages;
  UpdateStageListAction(this.pageState, this.stages);
}

class SetCustomStageNameAction{
  final NewJobTypePageState? pageState;
  final String? stageName;
  SetCustomStageNameAction(this.pageState, this.stageName);
}

class SaveNewStageAction{
  final NewJobTypePageState? pageState;
  SaveNewStageAction(this.pageState);
}




