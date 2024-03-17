import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/pages/job_types/JobTypesPageState.dart';

class FetchJobTypesAction{
  final JobTypesPageState? pageState;
  FetchJobTypesAction(this.pageState);
}

class SetJobTypesAction{
  final JobTypesPageState? pageState;
  final List<JobType>? jobTypes;
  SetJobTypesAction(this.pageState, this.jobTypes);
}

