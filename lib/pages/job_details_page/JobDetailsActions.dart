import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';

class SetJobInfo{
  final JobDetailsPageState pageState;
  final Job job;
  SetJobInfo(this.pageState, this.job);
}