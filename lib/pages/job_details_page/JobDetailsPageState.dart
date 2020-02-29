import 'dart:math';

import 'package:client_safe/models/Action.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/Notifications.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class JobDetailsPageState {
  final Job job;
  final Client client;
  final DateTime sunsetTime;
  final int newStagAnimationIndex;
  final double stageScrollOffset;
  final Map<DateTime, List<Event>> eventMap;
  final List<Job> jobs;
  final String jobTitleText;
  final List<Location> locations;
  final Location selectedLocation;
  final Function(Location) onLocationSelected;
  final List<int> expandedIndexes;
  final Function onStage1Selected;
  final Function onStage2Selected;
  final Function onStage3Selected;
  final Function onStage4Selected;
  final Function onStage5Selected;
  final Function onStage6Selected;
  final Function onStage7Selected;
  final Function onStage8Selected;
  final Function onStage9Selected;
  final Function onStage10Selected;
  final Function onStage11Selected;
  final Function onStage12Selected;
  final Function onStage13Selected;
  final Function onStage14Selected;
  final Function(Job, int) onStageCompleted;
  final Function(Job, int) onStageUndo;
  final Function(int) setNewIndexForStageAnimation;
  final Function(int) addExpandedIndex;
  final Function(int) removeExpandedIndex;
  final Function() onDeleteSelected;
  final Function() onInstagramSelected;
  final Function(double) onScrollOffsetChanged;
  final Function(DateTime) onNewTimeSelected;
  final Function(DateTime) onNewDateSelected;
  final Function(Client) onClientClicked;
  final Function(Job) onJobClicked;
  final Function(Location) onLocationSaveSelected;
  final Function(String) onJobTitleTextChanged;
  final Function() onNameChangeSaved;

  JobDetailsPageState({
    @required this.job,
    @required this.client,
    @required this.sunsetTime,
    @required this.eventMap,
    @required this.jobs,
    @required this.jobTitleText,
    @required this.locations,
    @required this.selectedLocation,
    @required this.onLocationSelected,
    @required this.expandedIndexes,
    @required this.stageScrollOffset,
    @required this.onStage1Selected,
    @required this.onStage2Selected,
    @required this.onStage3Selected,
    @required this.onStage4Selected,
    @required this.onStage5Selected,
    @required this.onStage6Selected,
    @required this.onStage7Selected,
    @required this.onStage8Selected,
    @required this.onStage9Selected,
    @required this.onStage10Selected,
    @required this.onStage11Selected,
    @required this.onStage12Selected,
    @required this.onStage13Selected,
    @required this.onStage14Selected,
    @required this.onStageCompleted,
    @required this.newStagAnimationIndex,
    @required this.onStageUndo,
    @required this.setNewIndexForStageAnimation,
    @required this.addExpandedIndex,
    @required this.removeExpandedIndex,
    @required this.onDeleteSelected,
    @required this.onInstagramSelected,
    @required this.onScrollOffsetChanged,
    @required this.onNewTimeSelected,
    @required this.onNewDateSelected,
    @required this.onClientClicked,
    @required this.onJobClicked,
    @required this.onLocationSaveSelected,
    @required this.onJobTitleTextChanged,
    @required this.onNameChangeSaved,
  });

  JobDetailsPageState copyWith({
    Job job,
    Client client,
    int newStagAnimationIndex,
    double stageScrollOffset,
    Map<DateTime, List<Event>> eventMap,
    List<Job> jobs,
    String jobTitleText,
    List<Location> locations,
    Location selectedLocation,
    Function(Location) onLocationSelected,
    List<int> expandedIndexes,
    Function(Job, int) onStageCompleted,
    Function(Job, int) onStageUndo,
    Function(int) setNewIndexForStageAnimation,
    Function(int) addExpandedIndex,
    Function(int) removeExpandedIndex,
    Function() onDeleteSelected,
    Function() onInstagramSelected,
    DateTime sunsetTime,
    Function(double) onScrollOffsetChanged,
    Function(DateTime) onNewTimeSelected,
    Function(DateTime) onNewDateSelected,
    Function(Client) onClientClicked,
    Function(Job) onJobClicked,
    Function(Location) onLocationSaveSelected,
    Function(String) onJobTitleTextChanged,
    Function() onNameChangeSaved,
  }){
    return JobDetailsPageState(
      job: job ?? this.job,
      client: client ?? this.client,
      sunsetTime: sunsetTime ?? this.sunsetTime,
      stageScrollOffset: stageScrollOffset ?? this.stageScrollOffset,
      eventMap: eventMap ?? this.eventMap,
      jobs: jobs ?? this.jobs,
      jobTitleText: jobTitleText ?? this.jobTitleText,
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      onLocationSelected: onLocationSelected ?? this.onLocationSelected,
      expandedIndexes: expandedIndexes ?? this.expandedIndexes,
      onStage1Selected: onStage1Selected ?? this.onStage1Selected,
      onStage2Selected: onStage2Selected ?? this.onStage2Selected,
      onStage3Selected: onStage3Selected ?? this.onStage3Selected,
      onStage4Selected: onStage4Selected ?? this.onStage4Selected,
      onStage5Selected: onStage5Selected ?? this.onStage5Selected,
      onStage6Selected: onStage6Selected ?? this.onStage6Selected,
      onStage7Selected: onStage7Selected ?? this.onStage7Selected,
      onStage8Selected: onStage8Selected ?? this.onStage8Selected,
      onStage9Selected: onStage9Selected ?? this.onStage9Selected,
      onStage10Selected: onStage10Selected ?? this.onStage10Selected,
      onStage11Selected: onStage11Selected ?? this.onStage11Selected,
      onStage12Selected: onStage12Selected ?? this.onStage12Selected,
      onStage13Selected: onStage13Selected ?? this.onStage13Selected,
      onStage14Selected: onStage14Selected ?? this.onStage14Selected,
      onStageCompleted: onStageCompleted ?? this.onStageCompleted,
      onStageUndo: onStageUndo ?? this.onStageUndo,
      newStagAnimationIndex: newStagAnimationIndex ?? this.newStagAnimationIndex,
      setNewIndexForStageAnimation: setNewIndexForStageAnimation ?? this.setNewIndexForStageAnimation,
      addExpandedIndex: addExpandedIndex ?? this.addExpandedIndex,
      removeExpandedIndex: removeExpandedIndex ?? this.removeExpandedIndex,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      onInstagramSelected: onInstagramSelected ?? this.onInstagramSelected,
      onScrollOffsetChanged: onScrollOffsetChanged ?? this.onScrollOffsetChanged,
      onNewTimeSelected: onNewTimeSelected ?? this.onNewTimeSelected,
      onNewDateSelected: onNewDateSelected ?? this.onNewDateSelected,
      onClientClicked: onClientClicked ?? this.onClientClicked,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      onLocationSaveSelected: onLocationSaveSelected ?? this.onLocationSaveSelected,
      onJobTitleTextChanged: onJobTitleTextChanged ?? this.onJobTitleTextChanged,
      onNameChangeSaved: onNameChangeSaved ?? this.onNameChangeSaved,
    );
  }

  static JobDetailsPageState fromStore(Store<AppState> store) {
    return JobDetailsPageState(
      job: store.state.jobDetailsPageState.job,
      client: store.state.jobDetailsPageState.client,
      sunsetTime: store.state.jobDetailsPageState.sunsetTime,
      stageScrollOffset: store.state.jobDetailsPageState.stageScrollOffset,
      eventMap: store.state.jobDetailsPageState.eventMap,
      jobs: store.state.jobDetailsPageState.jobs,
      jobTitleText: store.state.jobDetailsPageState.jobTitleText,
      locations: store.state.jobDetailsPageState.locations,
      selectedLocation: store.state.jobDetailsPageState.selectedLocation,
      expandedIndexes: store.state.jobDetailsPageState.expandedIndexes,
      newStagAnimationIndex: store.state.jobDetailsPageState.newStagAnimationIndex,
      onStage1Selected: store.state.jobDetailsPageState.onStage1Selected,
      onStage2Selected: store.state.jobDetailsPageState.onStage2Selected,
      onStage3Selected: store.state.jobDetailsPageState.onStage3Selected,
      onStage4Selected: store.state.jobDetailsPageState.onStage4Selected,
      onStage5Selected: store.state.jobDetailsPageState.onStage5Selected,
      onStage6Selected: store.state.jobDetailsPageState.onStage6Selected,
      onStage7Selected: store.state.jobDetailsPageState.onStage7Selected,
      onStage8Selected: store.state.jobDetailsPageState.onStage8Selected,
      onStage9Selected: store.state.jobDetailsPageState.onStage9Selected,
      onStage10Selected: store.state.jobDetailsPageState.onStage10Selected,
      onStage11Selected: store.state.jobDetailsPageState.onStage11Selected,
      onStage12Selected: store.state.jobDetailsPageState.onStage12Selected,
      onStage13Selected: store.state.jobDetailsPageState.onStage13Selected,
      onStage14Selected: store.state.jobDetailsPageState.onStage14Selected,
      onStageUndo: (job, stageIndex) => store.dispatch(UndoStageAction(store.state.jobDetailsPageState, job, stageIndex)),
      onStageCompleted: (job, stageIndex) => store.dispatch(SaveStageCompleted(store.state.jobDetailsPageState, job, stageIndex)),
      setNewIndexForStageAnimation: (index) => store.dispatch(SetNewStagAnimationIndex(store.state.jobDetailsPageState, index)),
      addExpandedIndex: (index) => store.dispatch(SetExpandedIndexAction(store.state.jobDetailsPageState, index)),
      removeExpandedIndex: (index) => store.dispatch(RemoveExpandedIndexAction(store.state.jobDetailsPageState, index)),
      onDeleteSelected: () => store.dispatch(DeleteJobAction(store.state.jobDetailsPageState)),
      onInstagramSelected: () => store.dispatch(JobInstagramSelectedAction(store.state.jobDetailsPageState)),
      onScrollOffsetChanged: (offset) => store.dispatch(UpdateScrollOffset(store.state.jobDetailsPageState, offset)),
      onNewTimeSelected: (newTime) => store.dispatch(UpdateJobTimeAction(store.state.jobDetailsPageState, newTime)),
      onNewDateSelected: (newDate) => store.dispatch(UpdateJobDateAction(store.state.jobDetailsPageState, newDate)),
      onClientClicked: (client) => store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
      onLocationSelected: (location) => store.dispatch(SetNewSelectedLocation(store.state.jobDetailsPageState, location)),
      onLocationSaveSelected: (location) => store.dispatch(UpdateNewLocationAction(store.state.jobDetailsPageState, location)),
      onJobTitleTextChanged: (newText) => store.dispatch(UpdateJobNameAction(store.state.jobDetailsPageState, newText)),
      onNameChangeSaved: () => store.dispatch(SaveJobNameChangeAction(store.state.jobDetailsPageState)),
    );
  }

  factory JobDetailsPageState.initial() => JobDetailsPageState(
    job: null,
    client: null,
    sunsetTime: null,
    stageScrollOffset: 200.0,
    newStagAnimationIndex: 2,
    eventMap: Map(),
    jobs: List(),
    jobTitleText: "",
    locations: List(),
    selectedLocation: null,
    expandedIndexes: List(),
    onStage1Selected: null,
    onStage2Selected: null,
    onStage3Selected: null,
    onStage4Selected: null,
    onStage5Selected: null,
    onStage6Selected: null,
    onStage7Selected: null,
    onStage8Selected: null,
    onStage9Selected: null,
    onStage10Selected: null,
    onStage11Selected: null,
    onStage12Selected: null,
    onStage13Selected: null,
    onStage14Selected: null,
    onStageCompleted: null,
    onStageUndo: null,
    addExpandedIndex: null,
    removeExpandedIndex: null,
    onDeleteSelected: null,
    onInstagramSelected: null,
    onScrollOffsetChanged: null,
    onNewTimeSelected: null,
    onNewDateSelected: null,
    onClientClicked: null,
    onJobClicked: null,
    onLocationSelected: null,
    onJobTitleTextChanged: null,
    onNameChangeSaved: null,
  );

  @override
  int get hashCode =>
      job.hashCode ^
      client.hashCode ^
      sunsetTime.hashCode ^
      stageScrollOffset.hashCode ^
      eventMap.hashCode ^
      jobs.hashCode ^
      jobTitleText.hashCode ^
      onNameChangeSaved.hashCode ^
      selectedLocation.hashCode ^
      onLocationSelected.hashCode ^
      locations.hashCode ^
      expandedIndexes.hashCode ^
      newStagAnimationIndex.hashCode ^
      onStage1Selected.hashCode ^
      onStage2Selected.hashCode ^
      onStage3Selected.hashCode ^
      onStage4Selected.hashCode ^
      onStage5Selected.hashCode ^
      onStage6Selected.hashCode ^
      onStage7Selected.hashCode ^
      onStage8Selected.hashCode ^
      onStage9Selected.hashCode ^
      onStage10Selected.hashCode ^
      onStage11Selected.hashCode ^
      onStage12Selected.hashCode ^
      onStage13Selected.hashCode ^
      onStage14Selected.hashCode ^
      onStageCompleted.hashCode ^
      onStageUndo.hashCode ^
      addExpandedIndex.hashCode ^
      removeExpandedIndex.hashCode ^
      onDeleteSelected.hashCode ^
      onInstagramSelected.hashCode ^
      onScrollOffsetChanged.hashCode ^
      onNewTimeSelected.hashCode ^
      onNewDateSelected.hashCode ^
      onClientClicked.hashCode ^
      onJobClicked.hashCode ^
      onJobTitleTextChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobDetailsPageState &&
              job == other.job &&
              client == other.client &&
              sunsetTime == other.sunsetTime &&
              stageScrollOffset == other.stageScrollOffset &&
              eventMap == other.eventMap &&
              jobs == other.jobs &&
              jobTitleText == other.jobTitleText &&
              onNameChangeSaved == other.onNameChangeSaved &&
              selectedLocation == other.selectedLocation &&
              onLocationSelected == other.onLocationSelected &&
              locations == other.locations &&
              expandedIndexes == other.expandedIndexes &&
              newStagAnimationIndex == other.newStagAnimationIndex &&
              onStage1Selected == other.onStage1Selected &&
              onStage2Selected == other.onStage2Selected &&
              onStage3Selected == other.onStage3Selected &&
              onStage4Selected == other.onStage4Selected &&
              onStage5Selected == other.onStage5Selected &&
              onStage6Selected == other.onStage6Selected &&
              onStage7Selected == other.onStage7Selected &&
              onStage8Selected == other.onStage8Selected &&
              onStage9Selected == other.onStage9Selected &&
              onStage10Selected == other.onStage10Selected &&
              onStage11Selected == other.onStage11Selected &&
              onStage12Selected == other.onStage12Selected &&
              onStage13Selected == other.onStage13Selected &&
              onStage14Selected == other.onStage14Selected &&
              onStageCompleted == other.onStageCompleted &&
              onStageUndo == other.onStageUndo &&
              addExpandedIndex == other.addExpandedIndex &&
              removeExpandedIndex ==other.removeExpandedIndex &&
              onDeleteSelected == other.onDeleteSelected &&
              onInstagramSelected == other.onInstagramSelected &&
              onScrollOffsetChanged == other.onScrollOffsetChanged &&
              onNewTimeSelected == other.onNewTimeSelected &&
              onNewDateSelected == other.onNewDateSelected &&
              onClientClicked == other.onClientClicked &&
              onJobClicked == other.onJobClicked &&
              onJobTitleTextChanged == other.onJobTitleTextChanged;
}
