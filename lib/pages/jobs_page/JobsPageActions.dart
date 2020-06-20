import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/jobs_page/JobsPageState.dart';

class JobSelectedAction{
  final JobsPageState pageState;
  JobSelectedAction(this.pageState);
}

class FilterChangedAction{
  final JobsPageState pageState;
  final String filterType;
  FilterChangedAction(this.pageState, this.filterType);
}

class SetJobsDataAction{
  final JobsPageState pageState;
  final List<Job> jobs;
  SetJobsDataAction(this.pageState, this.jobs);
}

class FetchJobsAction{
  final JobsPageState pageState;
  FetchJobsAction(this.pageState);
}