import '../../models/Job.dart';

class JobTypePieChartRowData {
  String? jobType;
  int? count;
  int? totalIncomeForType;
  List<Job>? jobs;
  int? color;

  JobTypePieChartRowData({
    this.jobType,
    this.count,
    this.totalIncomeForType,
    this.jobs,
    this.color,
  });
}