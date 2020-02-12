import 'package:client_safe/models/Action.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Notifications.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class JobDetailsPageState {
  final double stageScrollOffset;
  final Function(double) onOffsetChanged;

  JobDetailsPageState({
    @required this.stageScrollOffset,
    @required this.onOffsetChanged,
  });

  JobDetailsPageState copyWith({
    double stageScrollOffset,
    Function(double) onOffsetChanged,
  }){
    return JobDetailsPageState(
      stageScrollOffset: stageScrollOffset ?? this.stageScrollOffset,
      onOffsetChanged: onOffsetChanged ?? this.onOffsetChanged,
    );
  }

  static JobDetailsPageState fromStore(Store<AppState> store) {
    return JobDetailsPageState(
      stageScrollOffset: store.state.jobDetailsPageState.stageScrollOffset,
      onOffsetChanged: (offset) => store.dispatch(ScrollOffsetChangedAction(store.state.jobDetailsPageState, offset)),
    );
  }

  factory JobDetailsPageState.initial() => JobDetailsPageState(
    stageScrollOffset: 20.0,
    onOffsetChanged: null,
  );

  @override
  int get hashCode =>
      stageScrollOffset.hashCode ^
      onOffsetChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobDetailsPageState &&
              stageScrollOffset == other.stageScrollOffset &&
              onOffsetChanged == other.onOffsetChanged;
}
