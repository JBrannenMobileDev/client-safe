import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/pages/job_types/SessionTypesPageState.dart';

class FetchJobTypesAction{
  final SessionTypesPageState? pageState;
  FetchJobTypesAction(this.pageState);
}

class SetJobTypesAction{
  final SessionTypesPageState? pageState;
  final List<JobType>? jobTypes;
  SetJobTypesAction(this.pageState, this.jobTypes);
}

