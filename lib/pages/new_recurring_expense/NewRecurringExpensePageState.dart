import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewRecurringExpensePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";
  static const String BILLING_PERIOD_1MONTH = '1month';
  static const String BILLING_PERIOD_3MONTHS = '3months';
  static const String BILLING_PERIOD_6MONTHS = '6months';
  static const String BILLING_PERIOD_1YEAR = '1year';

  final int id;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final String expenseName;
  final bool isAutoPay;
  final DateTime expenseDate;
  final double expenseCost;
  final String billingPeriod;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function() onDeleteRecurringExpenseSelected;
  final Function(String) onNameChanged;
  final Function(DateTime) onExpenseDateSelected;
  final Function(String) onCostChanged;
  final Function(String) onBillingPeriodSelected;
  final Function(bool) onAutoPaySelected;

  NewRecurringExpensePageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.expenseName,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.onDeleteRecurringExpenseSelected,
    @required this.onNameChanged,
    @required this.onExpenseDateSelected,
    @required this.expenseDate,
    @required this.expenseCost,
    @required this.onCostChanged,
    @required this.billingPeriod,
    @required this.onBillingPeriodSelected,
    @required this.onAutoPaySelected,
    @required this.isAutoPay,
  });

  NewRecurringExpensePageState copyWith({
    int id,
    int pageViewIndex,
    saveButtonEnabled,
    bool shouldClear,
    bool isAutoPay,
    String expenseName,
    DateTime expenseDate,
    String billingPeriod,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function() onDeleteRecurringExpenseSelected,
    Function(String) onNameChanged,
    Function(DateTime) onExpenseDateSelected,
    double expenseCost,
    Function(String) onCostChanged,
    Function(String) onBillingPeriodSelected,
    Function(bool) onAutoPaySelected,
  }){
    return NewRecurringExpensePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      expenseName: expenseName?? this.expenseName,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onDeleteRecurringExpenseSelected: onDeleteRecurringExpenseSelected?? this.onDeleteRecurringExpenseSelected,
      onNameChanged: onNameChanged?? this.onNameChanged,
      onExpenseDateSelected: onExpenseDateSelected ?? this.onExpenseDateSelected,
      expenseDate: expenseDate ?? this.expenseDate,
      expenseCost: expenseCost ?? this.expenseCost,
      onCostChanged: onCostChanged ?? this.onCostChanged,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      onBillingPeriodSelected: onBillingPeriodSelected ?? this.onBillingPeriodSelected,
      onAutoPaySelected: onAutoPaySelected ?? this.onAutoPaySelected,
      isAutoPay: isAutoPay ?? this.isAutoPay,
    );
  }

  factory NewRecurringExpensePageState.initial() => NewRecurringExpensePageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        expenseName: "",
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onDeleteRecurringExpenseSelected: null,
        onNameChanged: null,
        expenseDate: null,
        onExpenseDateSelected: null,
        expenseCost: 0.0,
        onCostChanged: null,
        billingPeriod: BILLING_PERIOD_1MONTH,
        onBillingPeriodSelected: null,
        onAutoPaySelected: null,
        isAutoPay: true,
      );

  factory NewRecurringExpensePageState.fromStore(Store<AppState> store) {
    return NewRecurringExpensePageState(
      id: store.state.newRecurringExpensePageState.id,
      pageViewIndex: store.state.newRecurringExpensePageState.pageViewIndex,
      saveButtonEnabled: store.state.newRecurringExpensePageState.saveButtonEnabled,
      shouldClear: store.state.newRecurringExpensePageState.shouldClear,
      expenseName: store.state.newRecurringExpensePageState.expenseName,
      expenseDate: store.state.newRecurringExpensePageState.expenseDate,
      expenseCost: store.state.newRecurringExpensePageState.expenseCost,
      billingPeriod: store.state.newRecurringExpensePageState.billingPeriod,
      isAutoPay: store.state.newRecurringExpensePageState.isAutoPay,
      onSavePressed: () => store.dispatch(SaveRecurringExpenseProfileAction(store.state.newRecurringExpensePageState)),
      onCancelPressed: () => store.dispatch(ClearRecurringExpenseStateAction(store.state.newRecurringExpensePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newRecurringExpensePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newRecurringExpensePageState)),
      onDeleteRecurringExpenseSelected: () {
        store.dispatch(DeleteRecurringExpenseAction(store.state.newRecurringExpensePageState));
        store.dispatch(ClearRecurringExpenseStateAction(store.state.newRecurringExpensePageState));
      },
      onNameChanged: (profileName) => store.dispatch(UpdateExpenseNameAction(store.state.newRecurringExpensePageState, profileName)),
      onExpenseDateSelected: (expenseDate) => store.dispatch(SetExpenseDateAction(store.state.newRecurringExpensePageState, expenseDate)),
      onCostChanged: (newCost) => store.dispatch(UpdateCostAction(store.state.newRecurringExpensePageState, newCost)),
      onBillingPeriodSelected: (selectedPeriod) => store.dispatch(UpdateSelectedBillingPeriodAction(store.state.newRecurringExpensePageState, selectedPeriod)),
      onAutoPaySelected: (isAutoPay) => store.dispatch(UpdateAutoPaySelected(store.state.newRecurringExpensePageState, isAutoPay)),
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
      onDeleteRecurringExpenseSelected.hashCode ^
      onBillingPeriodSelected.hashCode ^
      onAutoPaySelected.hashCode ^
      isAutoPay.hashCode ^
      onExpenseDateSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewRecurringExpensePageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          onDeleteRecurringExpenseSelected == other.onDeleteRecurringExpenseSelected &&
          shouldClear == other.shouldClear &&
          expenseName == other.expenseName &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onNameChanged == other.onNameChanged &&
          expenseDate == other.expenseDate &&
          expenseCost == other.expenseCost &&
          isAutoPay == other.isAutoPay &&
          onBillingPeriodSelected == other.onBillingPeriodSelected &&
          onAutoPaySelected == other.onAutoPaySelected &&
          onExpenseDateSelected == other.onExpenseDateSelected;
}
