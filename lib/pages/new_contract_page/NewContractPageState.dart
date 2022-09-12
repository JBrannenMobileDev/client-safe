
import 'package:dandylight/pages/new_contract_page/NewContractActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class NewContractPageState{
  final int id;
  final String documentId;
  final bool shouldClear;
  final String documentFilePath;
  final String contractName;
  final int pageViewIndex;
  final Function() onSaveSelected;
  final Function() onDeleteSelected;
  final Function() onCanceledSelected;
  final Function(String) onNameChanged;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(String) saveFilePath;

  NewContractPageState({
    @required this.id,
    @required this.documentId,
    @required this.shouldClear,
    @required this.contractName,
    @required this.pageViewIndex,
    @required this.onSaveSelected,
    @required this.onDeleteSelected,
    @required this.onCanceledSelected,
    @required this.onNameChanged,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.documentFilePath,
    @required this.saveFilePath,
  });

  NewContractPageState copyWith({
    int id,
    String documentId,
    bool shouldClear,
    String contractName,
    int pageViewIndex,
    String documentFilePath,
    Function() onSaveSelected,
    Function() onDeleteSelected,
    Function() onCanceledSelected,
    Function(String) onNameChanged,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(String) saveFilePath,
  }){
    return NewContractPageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      shouldClear: shouldClear?? this.shouldClear,
      contractName: contractName?? this.contractName,
      pageViewIndex: pageViewIndex ?? this.pageViewIndex,
      documentFilePath: documentFilePath ?? this.documentFilePath,
      onSaveSelected: onSaveSelected?? this.onSaveSelected,
      onCanceledSelected: onCanceledSelected?? this.onCanceledSelected,
      onDeleteSelected: onDeleteSelected?? this.onDeleteSelected,
      onNameChanged: onNameChanged?? this.onNameChanged,
      onNextPressed: onNextPressed ?? this.onNextPressed,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      saveFilePath: saveFilePath ?? this.saveFilePath,
    );
  }

  factory NewContractPageState.initial() => NewContractPageState(
    id: null,
    documentId: '',
    shouldClear: true,
    contractName: "",
    pageViewIndex: 0,
    documentFilePath: '',
    onSaveSelected: null,
    onCanceledSelected: null,
    onDeleteSelected: null,
    onNameChanged: null,
    onNextPressed: null,
    onBackPressed: null,
    saveFilePath: null,
  );

  factory NewContractPageState.fromStore(Store<AppState> store) {
    return NewContractPageState(
      id: store.state.newLocationPageState.id,
      shouldClear: store.state.newLocationPageState.shouldClear,
      contractName: store.state.newLocationPageState.locationName,
      pageViewIndex: store.state.newLocationPageState.pageViewIndex,
      documentFilePath: store.state.newLocationPageState.documentFilePath,
      onSaveSelected: () => store.dispatch(SaveContractAction(store.state.newContractPageState)),
      onCanceledSelected: () => store.dispatch(ClearStateAction(store.state.newContractPageState)),
      onDeleteSelected: () => store.dispatch(DeleteContract(store.state.newContractPageState)),
      onNameChanged: (name) => store.dispatch(UpdateContractName(store.state.newContractPageState, name)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newContractPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newContractPageState)),
      saveFilePath: (filePath) => store.dispatch(SaveFilePathNewAction(store.state.newContractPageState, filePath)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      shouldClear.hashCode ^
      contractName.hashCode ^
      pageViewIndex.hashCode ^
      saveFilePath.hashCode ^
      onSaveSelected.hashCode ^
      onCanceledSelected.hashCode ^
      onDeleteSelected.hashCode ^
      documentFilePath.hashCode ^
      onNameChanged.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewContractPageState &&
              id == other.id &&
              documentId == other.documentId &&
              saveFilePath == other.saveFilePath &&
              shouldClear == other.shouldClear &&
              contractName == other.contractName &&
              pageViewIndex == other.pageViewIndex &&
              documentFilePath == other.documentFilePath &&
              onSaveSelected == other.onSaveSelected &&
              onCanceledSelected == other.onCanceledSelected &&
              onDeleteSelected == other.onDeleteSelected &&
              onNameChanged == other.onNameChanged;
}