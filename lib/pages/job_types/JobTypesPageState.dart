import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/JobType.dart';

class JobTypesPageState{

  final List<JobType> jobTypes;
  final Function(JobType) onJobTypeSelected;

  JobTypesPageState({
    @required this.jobTypes,
    @required this.onJobTypeSelected,
  });

  JobTypesPageState copyWith({
    List<JobType> jobTypes,
    Function(JobType) onJobTypeSelected,
  }){
    return JobTypesPageState(
      jobTypes: jobTypes ?? this.jobTypes,
      onJobTypeSelected: onJobTypeSelected?? this.onJobTypeSelected,
    );
  }

  factory JobTypesPageState.initial() => JobTypesPageState(
    jobTypes: [],
    onJobTypeSelected: null,
  );

  factory JobTypesPageState.fromStore(Store<AppState> store) {
    return JobTypesPageState(
      jobTypes: store.state.jobTypesPageState.jobTypes,
      onJobTypeSelected: (jobType) => null
      // onJobTypeSelected: (jobType) => store.dispatch(LoadExistingJobTypesData(store.state.newJobTypePageState, jobType)),
    );
  }

  @override
  int get hashCode =>
      jobTypes.hashCode ^
      onJobTypeSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobTypesPageState &&
              jobTypes == other.jobTypes &&
              onJobTypeSelected == other.onJobTypeSelected;
}