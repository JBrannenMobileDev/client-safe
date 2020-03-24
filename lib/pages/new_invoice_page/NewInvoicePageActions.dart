
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';

class FetchAllInvoiceJobsAction{
  final NewInvoicePageState pageState;
  FetchAllInvoiceJobsAction(this.pageState);
}

class SetAllJobsAction {
  final NewInvoicePageState pageState;
  final List<Job> allJobs;
  final List<Client> allClients;
  SetAllJobsAction(this.pageState, this.allJobs, this.allClients);
}

class IncrementPageViewIndex{
  final NewInvoicePageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewInvoicePageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class SaveNewJobAction{
  final NewInvoicePageState pageState;
  SaveNewJobAction(this.pageState);
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

class SaveSelectedFilter{
  final NewInvoicePageState pageState;
  final String selectedFilter;
  SaveSelectedFilter(this.pageState, this.selectedFilter);
}

class UpdateFlatRateText{
  final NewInvoicePageState pageState;
  final String flatRateText;
  UpdateFlatRateText(this.pageState, this.flatRateText);
}

class SetDiscountStateAction{
  final NewInvoicePageState pageState;
  final String newStage;
  SetDiscountStateAction(this.pageState, this.newStage);
}

class SaveSelectedDiscountTypeAction{
  final NewInvoicePageState pageState;
  final String discountType;
  SaveSelectedDiscountTypeAction(this.pageState, this.discountType);
}

class SaveFixedDiscountRateAction{
  final NewInvoicePageState pageState;
  final String discountStage;
  SaveFixedDiscountRateAction(this.pageState, this.discountStage);
}

class UpdateFixedDiscountPriceAction{
  final NewInvoicePageState pageState;
  final String fixedDiscountRate;
  UpdateFixedDiscountPriceAction(this.pageState, this.fixedDiscountRate);
}

class SavePercentageDiscountRateAction{
  final NewInvoicePageState pageState;
  final String discountStage;
  SavePercentageDiscountRateAction(this.pageState, this.discountStage);
}

class UpdatePercentageDiscountPriceAction{
  final NewInvoicePageState pageState;
  final String percentageDiscountRate;
  UpdatePercentageDiscountPriceAction(this.pageState, this.percentageDiscountRate);
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


