import 'package:client_safe/models/Action.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Notifications.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class JobDetailsPageState {
  final Job job;

  JobDetailsPageState({
    @required this.job,
  });

  JobDetailsPageState copyWith({
    Job job,
  }){
    return JobDetailsPageState(
      job: job ?? this.job,
    );
  }

  static JobDetailsPageState fromStore(Store<AppState> store) {
    return JobDetailsPageState(
      job: store.state.jobDetailsPageState.job,
    );
  }

  factory JobDetailsPageState.initial() => JobDetailsPageState(
    job: null,
  );

  @override
  int get hashCode =>
      job.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobDetailsPageState &&
              job == other.job;
}
