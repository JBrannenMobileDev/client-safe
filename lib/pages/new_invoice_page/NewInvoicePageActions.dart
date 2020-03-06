
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
