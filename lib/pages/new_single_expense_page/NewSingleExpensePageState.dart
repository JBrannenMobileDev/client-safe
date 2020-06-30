import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewSingleExpensePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int id;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final String expenseName;
  final DateTime expenseDate;
  final double expenseCost;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function() onDeleteSingleExpenseSelected;
  final Function(String) onNameChanged;
  final Function(DateTime) onExpenseDateSelected;
  final Function(String) onCostChanged;

  NewSingleExpensePageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.expenseName,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.onDeleteSingleExpenseSelected,
    @required this.onNameChanged,
    @required this.onExpenseDateSelected,
    @required this.expenseDate,
    @required this.expenseCost,
    @required this.onCostChanged,
  });

  NewSingleExpensePageState copyWith({
    int id,
    int pageViewIndex,
    saveButtonEnabled,
    bool shouldClear,
    String expenseName,
    DateTime expenseDate,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(PriceProfile) onDeleteSingleExpenseSelected,
    Function(String) onNameChanged,
    Function(DateTime) onExpenseDateSelected,
    double expenseCost,
    Function(String) onCostChanged,
  }){
    return NewSingleExpensePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      expenseName: expenseName?? this.expenseName,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onDeleteSingleExpenseSelected: onDeleteSingleExpenseSelected?? this.onDeleteSingleExpenseSelected,
      onNameChanged: onNameChanged?? this.onNameChanged,
      onExpenseDateSelected: onExpenseDateSelected ?? this.onExpenseDateSelected,
      expenseDate: expenseDate ?? this.expenseDate,
      expenseCost: expenseCost ?? this.expenseCost,
      onCostChanged: onCostChanged ?? this.onCostChanged,
    );
  }

  factory NewSingleExpensePageState.initial() => NewSingleExpensePageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        expenseName: "",
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onDeleteSingleExpenseSelected: null,
        onNameChanged: null,
        expenseDate: null,
        onExpenseDateSelected: null,
        expenseCost: 0.0,
        onCostChanged: null,
      );

  factory NewSingleExpensePageState.fromStore(Store<AppState> store) {
    return NewSingleExpensePageState(
      id: store.state.newSingleExpensePageState.id,
      pageViewIndex: store.state.newSingleExpensePageState.pageViewIndex,
      saveButtonEnabled: store.state.newSingleExpensePageState.saveButtonEnabled,
      shouldClear: store.state.newSingleExpensePageState.shouldClear,
      expenseName: store.state.newSingleExpensePageState.expenseName,
      expenseDate: store.state.newSingleExpensePageState.expenseDate,
      expenseCost: store.state.newSingleExpensePageState.expenseCost,
      onSavePressed: () => store.dispatch(SaveSingleExpenseProfileAction(store.state.newSingleExpensePageState)),
      onCancelPressed: () => store.dispatch(ClearSingleEpenseStateAction(store.state.newSingleExpensePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newSingleExpensePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newSingleExpensePageState)),
      onDeleteSingleExpenseSelected: () {
        store.dispatch(DeleteSingleExpenseAction(store.state.newSingleExpensePageState));
        store.dispatch(ClearSingleEpenseStateAction(store.state.newSingleExpensePageState));
      },
      onNameChanged: (profileName) => store.dispatch(UpdateExpenseNameAction(store.state.newSingleExpensePageState, profileName)),
      onExpenseDateSelected: (expenseDate) => store.dispatch(SetExpenseDateAction(store.state.newSingleExpensePageState, expenseDate)),
      onCostChanged: (newCost) => store.dispatch(UpdateCostAction(store.state.newSingleExpensePageState, newCost)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      expenseName.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onNameChanged.hashCode ^
      expenseDate.hashCode ^
      expenseCost.hashCode ^
      onDeleteSingleExpenseSelected.hashCode ^
      onExpenseDateSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewSingleExpensePageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          onDeleteSingleExpenseSelected == other.onDeleteSingleExpenseSelected &&
          shouldClear == other.shouldClear &&
          expenseName == other.expenseName &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onNameChanged == other.onNameChanged &&
          expenseDate == other.expenseDate &&
          expenseCost == other.expenseCost &&
          onExpenseDateSelected == other.onExpenseDateSelected;
}
