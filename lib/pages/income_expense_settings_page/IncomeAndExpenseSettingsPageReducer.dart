import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:dandylight/utils/StringUtils.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../models/RecurringExpense.dart';
import '../../models/Report.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'IncomeAndExpenseSettingsPageActions.dart';

final incomeAndExpenseSettingsPageReducer = combineReducers<IncomeAndExpenseSettingsPageState>([
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveZelleStateAction>(_saveZelleState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveVenmoStateAction>(_saveVenmoState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveCashAppStateAction>(_saveCashAppState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveApplePayStateAction>(_saveApplePayState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetZellePhoneEmailTextAction>(_setZellePhoneEmailText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetZelleFullNameTextAction>(_setZelleFullNameText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetVenmoLinkTextAction>(_setVenmoLinkText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetCashAppLinkTextAction>(_setCashAppLinkText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetApplePayPhoneTextAction>(_setApplePayPhoneText),
  TypedReducer<IncomeAndExpenseSettingsPageState, BuildIncomeExpenseReportAction>(_buildIncomeExpenseReport),
  TypedReducer<IncomeAndExpenseSettingsPageState, BuildMileageReportAction>(_buildMileageReport),
]);

IncomeAndExpenseSettingsPageState _buildMileageReport(IncomeAndExpenseSettingsPageState previousState, BuildMileageReportAction action){
  int startYear = 2023;
  int endYear = DateTime.now().year;
  List<Report> reports = [];
  List<String> header = ['Date', 'Distance driven'];

  for(startYear; startYear <= endYear ; startYear++) {
    reports.add(
        Report(
            header: header,
            rows: buildMileageRows(
              startYear,
              action.mileageExpenses!,
            ),
            year: startYear,
            type: Report.TYPE_MILEAGE,
        )
    );
  }

  return previousState.copyWith(
    mileageReports: reports,
  );
}

buildMileageRows(
    int year,
    List<MileageExpense> mileageExpenses,
) {
  List<MileageExpense> expensesForYear = mileageExpenses.where((expense) => expense.charge!.chargeDate!.year == year).toList();
  List<List<String>> rows = [];

  for (var expense in expensesForYear) {
    rows.add([
      DateFormat('MM-dd-yyyy').format(expense.charge!.chargeDate!),
      TextFormatterUtil.formatLargeNumber(expense.totalMiles!),
    ]);
  }

  rows.sort(compareRowByDate);

  double totalMilesDriven = 0;

  for(var row in rows) {
    if(row[1].isNotEmpty) {
      totalMilesDriven = totalMilesDriven + (double.tryParse(row[1].replaceAll(',', '')) ?? 0.0);
    }
  }

  rows.add([
    'Total miles driven: ',
    TextFormatterUtil.formatLargeNumber(totalMilesDriven)
  ]);
  return rows;
}

IncomeAndExpenseSettingsPageState _buildIncomeExpenseReport(IncomeAndExpenseSettingsPageState previousState, BuildIncomeExpenseReportAction action){
  List<Job> jobsWithPaymentReceived = action.allJobs!.where((job) => job.isPaymentReceived() == true).toList();
  List<Job> jobsWithOnlyDepositReceived = action.allJobs!.where((job) => job.isPaymentReceived() == false && job.isDepositPaid() == true).toList();

  int startYear = 2023;
  int endYear = DateTime.now().year;
  List<Report> reports = [];
  List<String> header = ['Date', 'Description', 'Income', 'Expense'];

  for(startYear; startYear <= endYear ; startYear++) {
    reports.add(
        Report(
          header: header,
          rows: buildIncomeAndExpenseRows(
            startYear,
            jobsWithPaymentReceived,
            jobsWithOnlyDepositReceived,
            action.singleExpenses!,
            action.recurringExpenses!,
          ),
          year: startYear,
          type: Report.TYPE_INCOME_EXPENSE,
        )
    );
  }

  return previousState.copyWith(
    incomeExpenseReports: reports,
  );
}

buildIncomeAndExpenseRows(
    int year,
    List<Job> jobsWithPaymentReceived,
    List<Job> jobsWithOnlyDepositReceived,
    List<SingleExpense> singleExpenses,
    List<RecurringExpense> recurringExpenses,
) {
  List<Job> paymentReceived = jobsWithPaymentReceived.where((job) => job.paymentReceivedDate!.year == year).toList();
  List<Job> onlyDepositReceived = jobsWithOnlyDepositReceived.where((job) => (job.depositReceivedDate?.year ?? job.paymentReceivedDate?.year) == year).toList();
  List<SingleExpense> singleForYear = singleExpenses.where((expense) => expense.charge!.chargeDate!.year == year).toList();
  List<List<String>> rows = [];

  //Add recurring charges for year
  for (var expense in recurringExpenses) {
    for (var charge in expense.charges!) {
      if(charge.chargeDate!.year == year) {
        rows.add([
          DateFormat('MM-dd-yyyy').format(charge.chargeDate!),
          expense.expenseName!,
          ' ',
          TextFormatterUtil.formatSimpleCurrencyNoNumberSign(charge.chargeAmount!)
        ]);
      }
    }
  }

  //Add single charges for year
  for (var singleExpense in singleForYear) {
    rows.add([
      DateFormat('MM-dd-yyyy').format(singleExpense.charge!.chargeDate!),
      singleExpense.expenseName!,
      ' ',
      TextFormatterUtil.formatSimpleCurrencyNoNumberSign(singleExpense.charge!.chargeAmount!)
    ]);
  }

  for (var job in paymentReceived) {
    double? tipAmount = (job.tipAmount != null && job.tipAmount! > 0 ? job.tipAmount : 0)?.toDouble();
    List<String> row = [
      DateFormat('MM-dd-yyyy').format(job.paymentReceivedDate!),
      job.jobTitle!,
      job.invoice != null ? TextFormatterUtil.formatSimpleCurrencyNoNumberSign(job.invoice!.total! + tipAmount!) : TextFormatterUtil.formatSimpleCurrencyNoNumberSign(job.sessionType!.getTotalPlusTax() + tipAmount!),
      ' ',
    ];
    rows.add(row);
  }

  for (var job in onlyDepositReceived) {
    double? tipAmount = (job.tipAmount != null && job.tipAmount! > 0 ? job.tipAmount : 0) as double?;
    List<String> row = [
      DateFormat('MM-dd-yyyy').format(job.depositReceivedDate!),
      '${job.jobTitle} - deposit only',
      job.depositAmount != null ? TextFormatterUtil.formatSimpleCurrencyNoNumberSign(job.depositAmount! + tipAmount!) : '0',
      ' ',
    ];
    rows.add(row);
  }

  rows.sort(compareRowByDate);

  double totalIncome = 0;
  double totalExpenses = 0;

  for(var row in rows) {
    if(row[2].isNotEmpty) {
      totalIncome = totalIncome + (double.tryParse(row[2].replaceAll(',', '')) ?? 0.0);
    }

    if(row[3].isNotEmpty) {
      totalExpenses = totalExpenses + (double.tryParse(row[3].replaceAll(',', '')) ?? 0.0);
    }
  }
  rows.add([
    ' ',
    'Totals: ',
    TextFormatterUtil.formatSimpleCurrencyNoNumberSign(totalIncome),
    TextFormatterUtil.formatSimpleCurrencyNoNumberSign(totalExpenses),
  ]);
  return rows;
}

int compareRowByDate(List<String> lhs, List<String> rhs) {
  String lhsDate = lhs[0];
  String rhsDate = rhs[0];
  return lhsDate.compareTo(rhsDate);
}

IncomeAndExpenseSettingsPageState _setZellePhoneEmailText(IncomeAndExpenseSettingsPageState previousState, SetZellePhoneEmailTextAction action){
  return previousState.copyWith(
    zellePhoneEmail: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setZelleFullNameText(IncomeAndExpenseSettingsPageState previousState, SetZelleFullNameTextAction action){
  return previousState.copyWith(
    zelleFullName: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setVenmoLinkText(IncomeAndExpenseSettingsPageState previousState, SetVenmoLinkTextAction action){
  return previousState.copyWith(
    venmoLink: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setCashAppLinkText(IncomeAndExpenseSettingsPageState previousState, SetCashAppLinkTextAction action){
  return previousState.copyWith(
    cashAppLink: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setApplePayPhoneText(IncomeAndExpenseSettingsPageState previousState, SetApplePayPhoneTextAction action){
  return previousState.copyWith(
    applePayPhone: action.input,
  );
}

IncomeAndExpenseSettingsPageState _saveZelleState(IncomeAndExpenseSettingsPageState previousState, SaveZelleStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Zelle",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled!,
  });
  return previousState.copyWith(
    zelleEnabled: action.enabled,
  );
}

IncomeAndExpenseSettingsPageState _saveVenmoState(IncomeAndExpenseSettingsPageState previousState, SaveVenmoStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Venmo",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled!,
  });
  return previousState.copyWith(
    venmoEnabled: action.enabled,
  );
}

IncomeAndExpenseSettingsPageState _saveCashAppState(IncomeAndExpenseSettingsPageState previousState, SaveCashAppStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Cash App",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled,
  });
  return previousState.copyWith(
    cashAppEnabled: action.enabled,
  );
}

IncomeAndExpenseSettingsPageState _saveApplePayState(IncomeAndExpenseSettingsPageState previousState, SaveApplePayStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Apple Pay",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled!,
  });
  return previousState.copyWith(
    applePayEnabled: action.enabled,
  );
}