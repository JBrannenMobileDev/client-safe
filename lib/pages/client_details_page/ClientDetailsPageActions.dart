import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';

import '../../models/ImportantDate.dart';

class InitializeClientDetailsAction{
  final ClientDetailsPageState pageState;
  final Client client;
  InitializeClientDetailsAction(this.pageState, this.client);
}

class SetTempLeadSourceAction{
  final ClientDetailsPageState pageState;
  final String leadSource;
  SetTempLeadSourceAction(this.pageState, this.leadSource);
}

class UpdateTempCustomLeadNameAction{
  final ClientDetailsPageState pageState;
  final String customName;
  UpdateTempCustomLeadNameAction(this.pageState, this.customName);
}

class DeleteClientAction{
  final ClientDetailsPageState pageState;
  DeleteClientAction(this.pageState);
}

class InstagramSelectedAction{
  final ClientDetailsPageState pageState;
  InstagramSelectedAction(this.pageState);
}

class OnSaveLeadSourceUpdateAction{
  final ClientDetailsPageState pageState;
  OnSaveLeadSourceUpdateAction(this.pageState);
}

class SetNotesAction{
  final ClientDetailsPageState pageState;
  final String notes;
  SetNotesAction(this.pageState, this.notes);
}

class SetClientJobsAction{
  final ClientDetailsPageState pageState;
  final List<Job> clientJobs;
  SetClientJobsAction(this.pageState, this.clientJobs);
}

class SaveNotesAction{
  final ClientDetailsPageState pageState;
  final String notes;
  SaveNotesAction(this.pageState, this.notes);
}

class AddClientDetailsImportantDateAction{
  final ClientDetailsPageState pageState;
  final ImportantDate importantDate;
  AddClientDetailsImportantDateAction(this.pageState, this.importantDate);
}

class RemoveClientDetailsImportantDateAction{
  final ClientDetailsPageState pageState;
  final int chipIndex;
  RemoveClientDetailsImportantDateAction(this.pageState, this.chipIndex);
}

class SaveImportantDatesAction{
  final ClientDetailsPageState pageState;
  SaveImportantDatesAction(this.pageState);
}


