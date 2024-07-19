import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/JobType.dart';

class SessionTypesPageState{

  final List<JobType>? jobTypes;
  final Function(JobType)? onJobTypeSelected;

  SessionTypesPageState({
    @required this.jobTypes,
    @required this.onJobTypeSelected,
  });

  SessionTypesPageState copyWith({
    List<JobType>? jobTypes,
    Function(JobType)? onJobTypeSelected,
  }){
    return SessionTypesPageState(
      jobTypes: jobTypes ?? this.jobTypes,
      onJobTypeSelected: onJobTypeSelected?? this.onJobTypeSelected,
    );
  }

  factory SessionTypesPageState.initial() => SessionTypesPageState(
    jobTypes: [],
    onJobTypeSelected: null,
  );

  factory SessionTypesPageState.fromStore(Store<AppState> store) {
    return SessionTypesPageState(
      jobTypes: store.state.jobTypesPageState!.jobTypes,
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
          other is SessionTypesPageState &&
              jobTypes == other.jobTypes &&
              onJobTypeSelected == other.onJobTypeSelected;
}