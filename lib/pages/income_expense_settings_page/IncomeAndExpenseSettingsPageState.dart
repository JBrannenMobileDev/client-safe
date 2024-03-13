import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Report.dart';
import 'IncomeAndExpenseSettingsPageActions.dart';

class IncomeAndExpenseSettingsPageState{
  final bool? zelleEnabled;
  final bool? venmoEnabled;
  final bool? cashAppEnabled;
  final bool? applePayEnabled;
  final String? zellePhoneEmail;
  final String? zelleFullName;
  final String? venmoLink;
  final String? cashAppLink;
  final String? applePayPhone;
  final List<Report>? incomeExpenseReports;
  final List<Report>? mileageReports;
  final Function(bool)? onZelleSelected;
  final Function(String)? onZelleTextPhoneEmailChanged;
  final Function(String)? onZelleTextFullNameChanged;
  final Function(bool)? onVenmoSelected;
  final Function(String)? onVenmoTextChanged;
  final Function(bool)? onCashAppSelected;
  final Function(String)? onCashAppTextChanged;
  final Function(bool)? onApplePaySelected;
  final Function(String)? onApplePayTextChanged;
  final Function()? onZellePhoneEmailInputDone;
  final Function()? onZelleFullNameInputDone;
  final Function()? onVenmoInputDone;
  final Function()? onCashAppInputDone;
  final Function()? onApplePayInputDone;
  final Function(Report)? onDownloadIncomeExpenseReport;
  final Function(Report)? onDownloadMileageReport;

  IncomeAndExpenseSettingsPageState({
    @required this.zelleEnabled,
    @required this.venmoEnabled,
    @required this.cashAppEnabled,
    @required this.applePayEnabled,
    @required this.onZelleSelected,
    @required this.onVenmoSelected,
    @required this.onCashAppSelected,
    @required this.onApplePaySelected,
    @required this.onZelleTextPhoneEmailChanged,
    @required this.onZelleTextFullNameChanged,
    @required this.onVenmoTextChanged,
    @required this.onCashAppTextChanged,
    @required this.onApplePayTextChanged,
    @required this.zellePhoneEmail,
    @required this.zelleFullName,
    @required this.venmoLink,
    @required this.cashAppLink,
    @required this.applePayPhone,
    @required this.onZelleFullNameInputDone,
    @required this.onZellePhoneEmailInputDone,
    @required this.onVenmoInputDone,
    @required this.onCashAppInputDone,
    @required this.onApplePayInputDone,
    @required this.incomeExpenseReports,
    @required this.mileageReports,
    @required this.onDownloadIncomeExpenseReport,
    @required this.onDownloadMileageReport,
  });

  IncomeAndExpenseSettingsPageState copyWith({
    bool? zelleEnabled,
    bool? venmoEnabled,
    bool? cashAppEnabled,
    bool? applePayEnabled,
    String? zellePhoneEmail,
    String? zelleFullName,
    String? venmoLink,
    String? cashAppLink,
    String? applePayPhone,
    List<Report>? incomeExpenseReports,
    List<Report>? mileageReports,
    Function()? onSignOutSelected,
    Function(bool)? onZelleSelected,
    Function(String)? onZelleTextPhoneEmailChanged,
    Function(String)? onZelleTextFullNameChanged,
    Function(bool)? onVenmoSelected,
    Function(String)? onVenmoTextChanged,
    Function(bool)? onCashAppSelected,
    Function(String)? onCashAppTextChanged,
    Function(bool)? onApplePaySelected,
    Function(String)? onApplePayTextChanged,
    Function()? onZellePhoneEmailInputDone,
    Function()? onZelleFullNameInputDone,
    Function()? onVenmoInputDone,
    Function()? onCashAppInputDone,
    Function()? onApplePayInputDone,
    Function(Report)? onDownloadIncomeExpenseReport,
    Function(Report)? onDownloadMileageReport,
  }){
    return IncomeAndExpenseSettingsPageState(
      zelleEnabled: zelleEnabled ?? this.zelleEnabled,
      venmoEnabled: venmoEnabled ?? this.venmoEnabled,
      cashAppEnabled: cashAppEnabled ?? this.cashAppEnabled,
      applePayEnabled: applePayEnabled ?? this.applePayEnabled,
      onCashAppSelected: onCashAppSelected ?? this.onCashAppSelected,
      onApplePaySelected: onApplePaySelected ?? this.onApplePaySelected,
      onZelleSelected: onZelleSelected ?? this.onZelleSelected,
      onVenmoSelected: onVenmoSelected ?? this.onVenmoSelected,
      onZelleTextPhoneEmailChanged: onZelleTextPhoneEmailChanged ?? this.onZelleTextPhoneEmailChanged,
      onZelleTextFullNameChanged: onZelleTextFullNameChanged ?? this.onZelleTextFullNameChanged,
      onVenmoTextChanged: onVenmoTextChanged ?? this.onVenmoTextChanged,
      onCashAppTextChanged: onCashAppTextChanged ?? this.onCashAppTextChanged,
      onApplePayTextChanged: onApplePayTextChanged ?? this.onApplePayTextChanged,
      zelleFullName: zelleFullName ?? this.zelleFullName,
      zellePhoneEmail: zellePhoneEmail ?? this.zellePhoneEmail,
      venmoLink: venmoLink ?? this.venmoLink,
      cashAppLink: cashAppLink ?? this.cashAppLink,
      applePayPhone: applePayPhone ?? this.applePayPhone,
      onZelleFullNameInputDone: onZelleFullNameInputDone ?? this.onZelleFullNameInputDone,
      onZellePhoneEmailInputDone: onZellePhoneEmailInputDone ?? this.onZellePhoneEmailInputDone,
      onVenmoInputDone: onVenmoInputDone ?? this.onVenmoInputDone,
      onCashAppInputDone: onCashAppInputDone ?? this.onCashAppInputDone,
      onApplePayInputDone: onApplePayInputDone ?? this.onApplePayInputDone,
      incomeExpenseReports: incomeExpenseReports ?? this.incomeExpenseReports,
      mileageReports: mileageReports ?? this.mileageReports,
      onDownloadIncomeExpenseReport: onDownloadIncomeExpenseReport ?? this.onDownloadIncomeExpenseReport,
      onDownloadMileageReport: onDownloadMileageReport ?? this.onDownloadMileageReport,
    );
  }

  factory IncomeAndExpenseSettingsPageState.initial() => IncomeAndExpenseSettingsPageState(
    onZelleSelected: null,
    onVenmoSelected: null,
    onCashAppSelected: null,
    onApplePaySelected: null,
    zelleEnabled: false,
    venmoEnabled: false,
    cashAppEnabled: false,
    applePayEnabled: false,
    onZelleTextPhoneEmailChanged: null,
    onZelleTextFullNameChanged: null,
    onVenmoTextChanged: null,
    onCashAppTextChanged: null,
    onApplePayTextChanged: null,
    zellePhoneEmail: '',
    zelleFullName: '',
    venmoLink: '',
    cashAppLink: '',
    applePayPhone: '',
    onZellePhoneEmailInputDone: null,
    onZelleFullNameInputDone: null,
    onVenmoInputDone: null,
    onCashAppInputDone: null,
    onApplePayInputDone: null,
    incomeExpenseReports: [],
    mileageReports: [],
    onDownloadIncomeExpenseReport: null,
    onDownloadMileageReport: null,
  );

  factory IncomeAndExpenseSettingsPageState.fromStore(Store<AppState> store) {
    return IncomeAndExpenseSettingsPageState(
      zelleEnabled: store.state.incomeAndExpenseSettingsPageState!.zelleEnabled,
      venmoEnabled: store.state.incomeAndExpenseSettingsPageState!.venmoEnabled,
      cashAppEnabled: store.state.incomeAndExpenseSettingsPageState!.cashAppEnabled,
      applePayEnabled: store.state.incomeAndExpenseSettingsPageState!.applePayEnabled,
      zelleFullName: store.state.incomeAndExpenseSettingsPageState!.zelleFullName,
      zellePhoneEmail: store.state.incomeAndExpenseSettingsPageState!.zellePhoneEmail,
      venmoLink: store.state.incomeAndExpenseSettingsPageState!.venmoLink,
      cashAppLink: store.state.incomeAndExpenseSettingsPageState!.cashAppLink,
      applePayPhone: store.state.incomeAndExpenseSettingsPageState!.applePayPhone,
      incomeExpenseReports: store.state.incomeAndExpenseSettingsPageState!.incomeExpenseReports,
      mileageReports: store.state.incomeAndExpenseSettingsPageState!.mileageReports,
      onZelleSelected: (enabled) => store.dispatch(SaveZelleStateAction(store.state.incomeAndExpenseSettingsPageState, enabled)),
      onVenmoSelected: (enabled) => store.dispatch(SaveVenmoStateAction(store.state.incomeAndExpenseSettingsPageState, enabled)),
      onCashAppSelected: (enabled) => store.dispatch(SaveCashAppStateAction(store.state.incomeAndExpenseSettingsPageState, enabled)),
      onApplePaySelected: (enabled) => store.dispatch(SaveApplePayStateAction(store.state.incomeAndExpenseSettingsPageState, enabled)),
      onZelleTextPhoneEmailChanged: (input) => store.dispatch(SetZellePhoneEmailTextAction(store.state.incomeAndExpenseSettingsPageState, input)),
      onZelleTextFullNameChanged: (input) => store.dispatch(SetZelleFullNameTextAction(store.state.incomeAndExpenseSettingsPageState, input)),
      onVenmoTextChanged: (input) => store.dispatch(SetVenmoLinkTextAction(store.state.incomeAndExpenseSettingsPageState, input)),
      onCashAppTextChanged: (input) => store.dispatch(SetCashAppLinkTextAction(store.state.incomeAndExpenseSettingsPageState, input)),
      onApplePayTextChanged: (input) => store.dispatch(SetApplePayPhoneTextAction(store.state.incomeAndExpenseSettingsPageState, input)),
      onZellePhoneEmailInputDone: () => store.dispatch(SaveZellePhoneEmailInput(store.state.incomeAndExpenseSettingsPageState)),
      onZelleFullNameInputDone: () => store.dispatch(SaveZelleFullNameInput(store.state.incomeAndExpenseSettingsPageState)),
      onVenmoInputDone: () => store.dispatch(SaveVenmoInput(store.state.incomeAndExpenseSettingsPageState)),
      onCashAppInputDone: () => store.dispatch(SaveCashAppInput(store.state.incomeAndExpenseSettingsPageState)),
      onApplePayInputDone: () => store.dispatch(SaveApplePayInput(store.state.incomeAndExpenseSettingsPageState)),
      onDownloadIncomeExpenseReport: (report) => store.dispatch(GenerateIncomeExpenseReportAction(store.state.incomeAndExpenseSettingsPageState, report)),
      onDownloadMileageReport: (report) => store.dispatch(GenerateMileageReportAction(store.state.incomeAndExpenseSettingsPageState, report)),
    );
  }

  @override
  int get hashCode =>
      zelleEnabled.hashCode ^
      venmoEnabled.hashCode ^
      cashAppEnabled.hashCode ^
      applePayEnabled.hashCode ^
      onZelleSelected.hashCode ^
      onVenmoSelected.hashCode ^
      onCashAppSelected.hashCode ^
      onApplePaySelected.hashCode ^
      onZelleTextFullNameChanged.hashCode ^
      onZelleTextPhoneEmailChanged.hashCode ^
      onVenmoTextChanged.hashCode ^
      onCashAppTextChanged.hashCode ^
      onApplePayTextChanged.hashCode ^
      zellePhoneEmail.hashCode ^
      zelleFullName.hashCode ^
      venmoLink.hashCode ^
      cashAppLink.hashCode ^
      onZellePhoneEmailInputDone.hashCode ^
      onZelleFullNameInputDone.hashCode ^
      onVenmoInputDone.hashCode ^
      onCashAppInputDone.hashCode ^
      onApplePayInputDone.hashCode ^
      incomeExpenseReports.hashCode ^
      mileageReports.hashCode ^
      onDownloadIncomeExpenseReport.hashCode ^
      onDownloadMileageReport.hashCode ^
      applePayPhone.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IncomeAndExpenseSettingsPageState &&
              zelleEnabled == other.zelleEnabled &&
              venmoEnabled == other.venmoEnabled &&
              cashAppEnabled == other.cashAppEnabled &&
              applePayEnabled == other.applePayEnabled &&
              onZelleSelected == other.onZelleSelected &&
              onVenmoSelected == other.onVenmoSelected &&
              onCashAppSelected == other.onCashAppSelected &&
              onApplePaySelected == other.onApplePaySelected &&
              onZelleTextPhoneEmailChanged == other.onZelleTextPhoneEmailChanged &&
              onZelleTextFullNameChanged == other.onZelleTextFullNameChanged &&
              onVenmoTextChanged == other.onVenmoTextChanged &&
              onCashAppTextChanged == other.onCashAppTextChanged &&
              onApplePayTextChanged == other.onApplePayTextChanged &&
              zelleFullName == other.zelleFullName &&
              zellePhoneEmail == other.zellePhoneEmail &&
              venmoLink == other.venmoLink &&
              cashAppLink == other.cashAppLink &&
              onZelleFullNameInputDone == other.onZelleFullNameInputDone &&
              onZellePhoneEmailInputDone == other.onZellePhoneEmailInputDone &&
              onVenmoInputDone == other.onVenmoInputDone &&
              onCashAppInputDone == other.onCashAppInputDone &&
              onApplePayInputDone == other.onApplePayInputDone &&
              incomeExpenseReports == other.incomeExpenseReports &&
              mileageReports == other.mileageReports &&
              onDownloadIncomeExpenseReport == other.onDownloadIncomeExpenseReport &&
              onDownloadMileageReport == other.onDownloadMileageReport &&
              applePayPhone == other.applePayPhone;
}