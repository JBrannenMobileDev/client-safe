
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';

class FetchAllInvoiceJobsAction{
  final NewInvoicePageState pageState;
  FetchAllInvoiceJobsAction(this.pageState);
}

class SetShouldClearAction{
  final NewInvoicePageState pageState;
  final bool shouldClear;
  SetShouldClearAction(this.pageState, this.shouldClear);
}

class SetAllJobsAction {
  final NewInvoicePageState pageState;
  final List<Job> allJobs;
  final List<Client> allClients;
  final int newInvoiceNumber;
  final double salesTaxRate;
  SetAllJobsAction(this.pageState, this.allJobs, this.allClients, this.newInvoiceNumber, this.salesTaxRate);
}

class IncrementPageViewIndex{
  final NewInvoicePageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewInvoicePageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class SaveNewInvoiceAction{
  final NewInvoicePageState pageState;
  SaveNewInvoiceAction(this.pageState);
}

class FilterClientList{
  final NewInvoicePageState pageState;
  final String textInput;
  FilterClientList(this.pageState, this.textInput);
}

class ClearSearchInputActon{
  final NewInvoicePageState pageState;
  ClearSearchInputActon(this.pageState);
}

class ClearStateAction{
  final NewInvoicePageState pageState;
  ClearStateAction(this.pageState);
}

class SaveSelectedJobAction {
  final NewInvoicePageState pageState;
  final Job selectedJob;
  SaveSelectedJobAction(this.pageState, this.selectedJob);
}

class FilterJobList{
  final NewInvoicePageState pageState;
  final String searchText;
  FilterJobList(this.pageState, this.searchText);
}

class UpdateFlatRateText{
  final NewInvoicePageState pageState;
  final String flatRateText;
  UpdateFlatRateText(this.pageState, this.flatRateText);
}

class UpdateNewInvoiceHourlyRateTextAction{
  final NewInvoicePageState pageState;
  final String hourlyRate;
  UpdateNewInvoiceHourlyRateTextAction(this.pageState, this.hourlyRate);
}

class UpdateNewInvoiceHourlyQuantityTextAction{
  final NewInvoicePageState pageState;
  final String hourlyQuantity;
  UpdateNewInvoiceHourlyQuantityTextAction(this.pageState, this.hourlyQuantity);
}

class UpdateNewInvoiceItemTextAction{
  final NewInvoicePageState pageState;
  final String itemRate;
  UpdateNewInvoiceItemTextAction(this.pageState, this.itemRate);
}

class UpdateNewInvoiceItemQuantityAction{
  final NewInvoicePageState pageState;
  final String itemQuantity;
  UpdateNewInvoiceItemQuantityAction(this.pageState, this.itemQuantity);
}

class SaveNewLineItemAction{
  final NewInvoicePageState pageState;
  SaveNewLineItemAction(this.pageState);
}

class ClearNewLineItemAction{
  final NewInvoicePageState pageState;
  ClearNewLineItemAction(this.pageState);
}

class UpdateLineItemNameAction{
  final NewInvoicePageState pageState;
  final String name;
  UpdateLineItemNameAction(this.pageState, this.name);
}

class UpdateLineItemRateAction{
  final NewInvoicePageState pageState;
  final String rate;
  UpdateLineItemRateAction(this.pageState, this.rate);
}

class UpdateLineItemQuantityAction{
  final NewInvoicePageState pageState;
  final String quantity;
  UpdateLineItemQuantityAction(this.pageState, this.quantity);
}

class DeleteLineItemAction{
  final NewInvoicePageState pageState;
  final int index;
  DeleteLineItemAction(this.pageState, this.index);
}

class UpdateNewDiscountSelectorAction{
  final NewInvoicePageState pageState;
  final String selectorName;
  UpdateNewDiscountSelectorAction(this.pageState, this.selectorName);
}

class ClearNewDiscountAction{
  final NewInvoicePageState pageState;
  ClearNewDiscountAction(this.pageState);
}

class SaveNewDiscountAction{
  final NewInvoicePageState pageState;
  SaveNewDiscountAction(this.pageState);
}

class UpdateNewDiscountPercentageTextAction{
  final NewInvoicePageState pageState;
  final String percentage;
  UpdateNewDiscountPercentageTextAction(this.pageState, this.percentage);
}

class UpdateNewDiscountRateTextAction{
  final NewInvoicePageState pageState;
  final String rate;
  UpdateNewDiscountRateTextAction(this.pageState, this.rate);
}

class DeleteDiscountAction{
  final NewInvoicePageState pageState;
  DeleteDiscountAction(this.pageState);
}

class SetSelectedDueDate{
  final NewInvoicePageState pageState;
  final DateTime selectedDueDate;
  SetSelectedDueDate(this.pageState, this.selectedDueDate);
}

class UpdateDepositStatusAction{
  final NewInvoicePageState pageState;
  final bool isChecked;
  UpdateDepositStatusAction(this.pageState, this.isChecked);
}

class GenerateInvoicePdfAction{
  final NewInvoicePageState pageState;
  GenerateInvoicePdfAction(this.pageState);
}

class UpdatePdfSavedFlag{
  final NewInvoicePageState pageState;
  UpdatePdfSavedFlag(this.pageState);
}

class SetDepositCheckBoxStateAction {
  final NewInvoicePageState pageState;
  final bool isChecked;
  SetDepositCheckBoxStateAction(this.pageState, this.isChecked);
}

class SetSalesTaxCheckBoxStateAction {
  final NewInvoicePageState pageState;
  final bool isChecked;
  SetSalesTaxCheckBoxStateAction(this.pageState, this.isChecked);
}

class SetSelectedSalesTaxRate {
  final NewInvoicePageState pageState;
  final String rate;
  SetSelectedSalesTaxRate(this.pageState, this.rate);
}

class UpdateJobOnInvoiceSent{
  final NewInvoicePageState pageState;
  UpdateJobOnInvoiceSent(this.pageState);
}


