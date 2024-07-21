import '../../models/Job.dart';

class SessionTypePieChartRowData {
  String? sessionType;
  int? count;
  int? totalIncomeForType;
  List<Job>? jobs;
  int? color;

  SessionTypePieChartRowData({
    this.sessionType,
    this.count,
    this.totalIncomeForType,
    this.jobs,
    this.color,
  });
}