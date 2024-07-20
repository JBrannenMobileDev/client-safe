import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/SessionType.dart';

class SessionTypesPageState{

  final List<SessionType>? sessionTypes;

  SessionTypesPageState({
    @required this.sessionTypes,
  });

  SessionTypesPageState copyWith({
    List<SessionType>? sessionType,
    Function(SessionType)? onSessionTypeSelected,
  }){
    return SessionTypesPageState(
      sessionTypes: sessionType ?? this.sessionTypes,
    );
  }

  factory SessionTypesPageState.initial() => SessionTypesPageState(
    sessionTypes: [],
  );

  factory SessionTypesPageState.fromStore(Store<AppState> store) {
    return SessionTypesPageState(
      sessionTypes: store.state.sessionTypesPageState!.sessionTypes,
    );
  }

  @override
  int get hashCode =>
      sessionTypes.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SessionTypesPageState &&
              sessionTypes == other.sessionTypes;
}