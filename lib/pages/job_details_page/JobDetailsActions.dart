import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';

class SetJobInfo{
  final JobDetailsPageState pageState;
  final Job job;
  SetJobInfo(this.pageState, this.job);
}

class JobInstagramSelectedAction{
  final JobDetailsPageState pageState;
  JobInstagramSelectedAction(this.pageState);
}

class SaveStageCompleted{
  final JobDetailsPageState pageState;
  final Job job;
  final int stageIndex;
  SaveStageCompleted(this.pageState, this.job, this.stageIndex);
}

class UndoStageAction{
  final JobDetailsPageState pageState;
  final Job job;
  final int stageIndex;
  UndoStageAction(this.pageState, this.job, this.stageIndex);
}

class SetNewStagAnimationIndex{
  final JobDetailsPageState pageState;
  final int newStagAnimationIndex;
  SetNewStagAnimationIndex(this.pageState, this.newStagAnimationIndex);
}

class SetExpandedIndexAction{
  final JobDetailsPageState pageState;
  final int index;
  SetExpandedIndexAction(this.pageState, this.index);
}

class RemoveExpandedIndexAction{
  final JobDetailsPageState pageState;
  final int index;
  RemoveExpandedIndexAction(this.pageState, this.index);
}

class DeleteJobAction{
  final JobDetailsPageState pageState;
  DeleteJobAction(this.pageState);
}

class SetClientAction{
  final JobDetailsPageState pageState;
  final Client client;
  SetClientAction(this.pageState, this.client);
}