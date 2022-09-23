
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'NewPoseGroupActions.dart';

class NewPoseGroupPageState{
  final int id;
  final String documentId;
  final String groupName;
  final Function() onSaveSelected;
  final Function() onCanceledSelected;
  final Function(String) onNameChanged;

  NewPoseGroupPageState({
    @required this.id,
    @required this.documentId,
    @required this.groupName,
    @required this.onSaveSelected,
    @required this.onCanceledSelected,
    @required this.onNameChanged,
  });

  NewPoseGroupPageState copyWith({
    int id,
    String documentId,
    String groupName,
    Function() onSaveSelected,
    Function() onCanceledSelected,
    Function(String) onNameChanged,
  }){
    return NewPoseGroupPageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      groupName: groupName?? this.groupName,
      onSaveSelected: onSaveSelected?? this.onSaveSelected,
      onCanceledSelected: onCanceledSelected?? this.onCanceledSelected,
      onNameChanged: onNameChanged?? this.onNameChanged,
    );
  }

  factory NewPoseGroupPageState.initial() => NewPoseGroupPageState(
    id: null,
    documentId: '',
    groupName: "",
    onSaveSelected: null,
    onCanceledSelected: null,
    onNameChanged: null,
  );

  factory NewPoseGroupPageState.fromStore(Store<AppState> store) {
    return NewPoseGroupPageState(
      id: store.state.newPoseGroupPageState.id,
      documentId: store.state.newPoseGroupPageState.documentId,
      groupName: store.state.newPoseGroupPageState.groupName,
      onSaveSelected: () => store.dispatch(SaveAction(store.state.newPoseGroupPageState)),
      onNameChanged: (name) => store.dispatch(UpdateName(store.state.newPoseGroupPageState, name)),
      onCanceledSelected: () => store.dispatch(ClearStateAction(store.state.newPoseGroupPageState))
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      groupName.hashCode ^
      onSaveSelected.hashCode ^
      onCanceledSelected.hashCode ^
      onNameChanged.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewPoseGroupPageState &&
              id == other.id &&
              documentId == other.documentId &&
              groupName == other.groupName &&
              onSaveSelected == other.onSaveSelected &&
              onCanceledSelected == other.onCanceledSelected &&
              onNameChanged == other.onNameChanged;
}