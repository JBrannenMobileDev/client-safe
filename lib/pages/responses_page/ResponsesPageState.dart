


import 'package:dandylight/models/Response.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/ResponsesListItem.dart';
import 'ResponsesActions.dart';

class ResponsesPageState{
  final bool isEditEnabled;
  final List<ResponsesListItem> items;
  final Function() onEditSelected;
  final Function() onAddGroupSelected;
  final Function(ResponsesListItem) onDeleteSelected;
  final Function() onCancelSelected;
  final Function() onSaveNewCategorySelected;
  final Function(Response) onSaveNewResponseSelected;
  final Function(String) onNewCategoryNameChanged;
  final Function(String) onNewResponseTitleChanged;
  final Function(String) onNewResponseMessageChanged;
  final Function(ResponsesListItem) onUpdateResponseSelected;


  ResponsesPageState({
    @required this.items,
    @required this.onEditSelected,
    @required this.onAddGroupSelected,
    @required this.onDeleteSelected,
    @required this.onCancelSelected,
    @required this.onSaveNewCategorySelected,
    @required this.onSaveNewResponseSelected,
    @required this.onNewCategoryNameChanged,
    @required this.onNewResponseMessageChanged,
    @required this.onNewResponseTitleChanged,
    @required this.onUpdateResponseSelected,
    @required this.isEditEnabled,
  });

  ResponsesPageState copyWith({
    List<ResponsesListItem> items,
    Function() onEditSelected,
    Function() onAddGroupSelected,
    Function(ResponsesListItem) onAddResponseSelected,
    Function(ResponsesListItem) onDeleteSelected,
    Function() onCancelSelected,
    Function() onSaveNewCategorySelected,
    Function(Response) onSaveNewResponseSelected,
    Function(String) onNewCategoryNameChanged,
    Function(String) onNewResponseTitleChanged,
    Function(String) onNewResponseMessageChanged,
    Function(ResponsesListItem) onUpdateResponseSelected,
     bool isEditEnabled,
  }){
    return ResponsesPageState(
      items: items?? this.items,
      onEditSelected: onEditSelected?? this.onEditSelected,
      onAddGroupSelected: onAddGroupSelected?? this.onAddGroupSelected,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      onCancelSelected: onCancelSelected ?? this.onCancelSelected,
      onNewCategoryNameChanged: onNewCategoryNameChanged ?? this.onNewCategoryNameChanged,
      onNewResponseMessageChanged: onNewResponseMessageChanged ?? this.onNewResponseMessageChanged,
      onNewResponseTitleChanged: onNewResponseTitleChanged ?? this.onNewResponseTitleChanged,
      onSaveNewCategorySelected: onSaveNewCategorySelected ?? this.onSaveNewCategorySelected,
      onSaveNewResponseSelected: onSaveNewResponseSelected ?? this.onSaveNewResponseSelected,
      onUpdateResponseSelected: onUpdateResponseSelected ?? this.onUpdateResponseSelected,
      isEditEnabled: isEditEnabled ?? this.isEditEnabled,
    );
  }

  factory ResponsesPageState.initial() => ResponsesPageState(
    items: [],
    onEditSelected: null,
    onAddGroupSelected: null,
    onDeleteSelected: null,
    onCancelSelected: null,
    onSaveNewResponseSelected: null,
    onSaveNewCategorySelected: null,
    onNewResponseTitleChanged: null,
    onNewResponseMessageChanged: null,
    onNewCategoryNameChanged: null,
    onUpdateResponseSelected: null,
    isEditEnabled: false,
  );

  factory ResponsesPageState.fromStore(Store<AppState> store) {
    return ResponsesPageState(
      items: store.state.responsesPageState.items,
      isEditEnabled: store.state.responsesPageState.isEditEnabled,
      onEditSelected: () => store.dispatch(UpdateEditStateAction(store.state.responsesPageState)),
      onAddGroupSelected: () => null,
      onDeleteSelected: (item) => store.dispatch(DeleteResponseAction(store.state.responsesPageState, item)),
      onCancelSelected: () => null,
      onSaveNewCategorySelected: () => null,
      onSaveNewResponseSelected: (response) => store.dispatch(SaveNewResponseAction(store.state.responsesPageState, response)),
      onNewCategoryNameChanged: (name) => store.dispatch(UpdateNewCategoryName(store.state.responsesPageState, name)),
      onNewResponseTitleChanged: (title) => null,
      onNewResponseMessageChanged: (message) => null,
      onUpdateResponseSelected: (responseListItem) => store.dispatch(UpdateResponseAction(store.state.responsesPageState, responseListItem)),
    );
  }

  @override
  int get hashCode =>
      items.hashCode ^
      onEditSelected.hashCode ^
      onAddGroupSelected.hashCode ^
      onDeleteSelected.hashCode ^
      onCancelSelected.hashCode ^
      onSaveNewResponseSelected.hashCode ^
      onSaveNewCategorySelected.hashCode ^
      onNewResponseTitleChanged.hashCode ^
      onNewResponseMessageChanged.hashCode ^
      onNewCategoryNameChanged.hashCode ^
      isEditEnabled.hashCode ^
      onUpdateResponseSelected.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ResponsesPageState &&
              items == other.items &&
              onEditSelected == other.onEditSelected &&
              onAddGroupSelected == other.onAddGroupSelected &&
              onCancelSelected == other.onCancelSelected &&
              onSaveNewCategorySelected == other.onSaveNewCategorySelected &&
              onSaveNewResponseSelected == other.onSaveNewResponseSelected &&
              onNewCategoryNameChanged == other.onNewCategoryNameChanged &&
              onNewResponseMessageChanged == other.onNewResponseMessageChanged &&
              onNewResponseTitleChanged == other.onNewResponseTitleChanged &&
              onUpdateResponseSelected == other.onUpdateResponseSelected &&
              isEditEnabled == other.isEditEnabled &&
              onDeleteSelected == other.onDeleteSelected;
}