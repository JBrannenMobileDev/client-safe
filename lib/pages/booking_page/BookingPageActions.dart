import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';

import '../../models/ImportantDate.dart';
import '../../models/Response.dart';
import 'BookingPageState.dart';

class InitializeClientDetailsAction{
  final BookingPageState? pageState;
  final Client? client;
  InitializeClientDetailsAction(this.pageState, this.client);
}

class SetTempLeadSourceAction{
  final BookingPageState? pageState;
  final String? leadSource;
  SetTempLeadSourceAction(this.pageState, this.leadSource);
}

class UpdateTempCustomLeadNameAction{
  final BookingPageState? pageState;
  final String? customName;
  UpdateTempCustomLeadNameAction(this.pageState, this.customName);
}

class DeleteClientAction{
  final BookingPageState? pageState;
  DeleteClientAction(this.pageState);
}

class InstagramSelectedAction{
  final BookingPageState? pageState;
  InstagramSelectedAction(this.pageState);
}

class OnSaveLeadSourceUpdateAction{
  final BookingPageState? pageState;
  OnSaveLeadSourceUpdateAction(this.pageState);
}

class SetNotesAction{
  final BookingPageState? pageState;
  final String? notes;
  SetNotesAction(this.pageState, this.notes);
}

class SetClientJobsAction{
  final BookingPageState? pageState;
  final List<Job>? clientJobs;
  SetClientJobsAction(this.pageState, this.clientJobs);
}

class SaveNotesAction{
  final BookingPageState? pageState;
  final String? notes;
  SaveNotesAction(this.pageState, this.notes);
}

class AddClientDetailsImportantDateAction{
  final BookingPageState? pageState;
  final ImportantDate? importantDate;
  AddClientDetailsImportantDateAction(this.pageState, this.importantDate);
}

class RemoveClientDetailsImportantDateAction{
  final BookingPageState? pageState;
  final int? chipIndex;
  RemoveClientDetailsImportantDateAction(this.pageState, this.chipIndex);
}

class SaveImportantDatesAction{
  final BookingPageState? pageState;
  SaveImportantDatesAction(this.pageState);
}

class FetchClientDetailsResponsesAction{
  final BookingPageState? pageState;
  FetchClientDetailsResponsesAction(this.pageState);
}

class SetClientDetailsResponsesAction{
  final BookingPageState? pageState;
  final List<Response>? responses;
  SetClientDetailsResponsesAction(this.pageState, this.responses);
}


