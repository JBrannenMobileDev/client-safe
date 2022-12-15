import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:redux/redux.dart';
import '../../models/ImportantDate.dart';
import '../../models/Response.dart';
import '../../models/ResponsesListItem.dart';
import 'ClientDetailsPageState.dart';

final clientDetailsPageReducer = combineReducers<ClientDetailsPageState>([
  TypedReducer<ClientDetailsPageState, InitializeClientDetailsAction>(_setClient),
  TypedReducer<ClientDetailsPageState, SetClientJobsAction>(_setJobs),
  TypedReducer<ClientDetailsPageState, SetTempLeadSourceAction>(_setLeadSource),
  TypedReducer<ClientDetailsPageState, UpdateTempCustomLeadNameAction>(_setCustomLeadSourceName),
  TypedReducer<ClientDetailsPageState, SetNotesAction>(_setNotes),
  TypedReducer<ClientDetailsPageState, AddClientDetailsImportantDateAction>(_addImportantDate),
  TypedReducer<ClientDetailsPageState, RemoveClientDetailsImportantDateAction>(_removeImportantDate),
  TypedReducer<ClientDetailsPageState, SetClientDetailsResponsesAction>(_setResponses),
]);

ClientDetailsPageState _removeImportantDate(ClientDetailsPageState previousState, RemoveClientDetailsImportantDateAction action) {
  for(ImportantDate date in previousState.importantDates){
    if(date.chipIndex == action.chipIndex){
      previousState.importantDates.remove(date);
      break;
    }
  }
  return previousState.copyWith(
      importantDates: previousState.importantDates
  );
}

ClientDetailsPageState _addImportantDate(ClientDetailsPageState previousState, AddClientDetailsImportantDateAction action) {
  previousState.importantDates.add(action.importantDate);
  return previousState.copyWith(
      importantDates: previousState.importantDates
  );
}

ClientDetailsPageState _setNotes(ClientDetailsPageState previousState, SetNotesAction action){
  return previousState.copyWith(
    notes: action.notes,
  );
}

ClientDetailsPageState _setCustomLeadSourceName(ClientDetailsPageState previousState, UpdateTempCustomLeadNameAction action){
  return previousState.copyWith(
    customLeadSourceName: action.customName,
  );
}

ClientDetailsPageState _setLeadSource(ClientDetailsPageState previousState, SetTempLeadSourceAction action){
  return previousState.copyWith(
    leadSource: action.leadSource,
    customLeadSourceName: '',
  );
}

ClientDetailsPageState _setClient(ClientDetailsPageState previousState, InitializeClientDetailsAction action){
  return previousState.copyWith(
    client: action.client,
    leadSource: action.client.leadSource,
    customLeadSourceName: action.client.customLeadSourceName,
    importantDates: action.client.importantDates,
  );
}

ClientDetailsPageState _setJobs(ClientDetailsPageState previousState, SetClientJobsAction action){
  if(previousState.client != null) {
    return previousState.copyWith(
      clientJobs: action.clientJobs.where((job) => job.clientDocumentId == previousState.client.documentId).toList(),
    );
  }
  return previousState;
}

ClientDetailsPageState _setResponses(ClientDetailsPageState previousState, SetClientDetailsResponsesAction action){
  List<ResponsesListItem> result = [];
  List<ResponsesListItem> preBookingResponses = [];
  List<ResponsesListItem> prePhotoshootResponses = [];
  List<ResponsesListItem> postPhotoshootResponses = [];

  for(Response response in action.responses) {
    switch(response.parentGroup) {
      case Response.GROUP_TITLE_PRE_BOOKING:
        preBookingResponses.add(ResponsesListItem(
            itemType: ResponsesListItem.RESPONSE,
            title: response.title,
            response: response,
            groupName: Response.GROUP_TITLE_PRE_BOOKING
        ));
        break;
      case Response.GROUP_TITLE_PRE_PHOTOSHOOT:
        prePhotoshootResponses.add(ResponsesListItem(
            itemType: ResponsesListItem.RESPONSE,
            title: response.title,
            response: response,
            groupName: Response.GROUP_TITLE_PRE_PHOTOSHOOT
        ));
        break;
      case Response.GROUP_TITLE_POST_PHOTOSHOOT:
        postPhotoshootResponses.add(ResponsesListItem(
            itemType: ResponsesListItem.RESPONSE,
            title: response.title,
            response: response,
            groupName: Response.GROUP_TITLE_POST_PHOTOSHOOT
        ));
        break;
    }
  }

  //Add pre booking items
  result.add(ResponsesListItem(
      itemType: ResponsesListItem.GROUP_TITLE,
      title: Response.GROUP_TITLE_PRE_BOOKING
  ));
  int preBookingCount = 0;
  for(ResponsesListItem response in preBookingResponses) {
    if(response.response.message != null && response.response.message.isNotEmpty) {
      result.add(response);
      preBookingCount++;
    }
  }
  if(preBookingCount == 0) {
    result.add(ResponsesListItem(
      itemType: ResponsesListItem.NO_SAVED_RESPONSES,
      groupName: Response.GROUP_TITLE_PRE_BOOKING
    ));
  }

  //Add pre photoshoot items
  result.add(ResponsesListItem(
      itemType: ResponsesListItem.GROUP_TITLE,
      title: Response.GROUP_TITLE_PRE_PHOTOSHOOT
  ));
  int prePhotoshootCount = 0;
  for(ResponsesListItem response in prePhotoshootResponses) {
    if(response.response.message != null && response.response.message.isNotEmpty) {
      result.add(response);
      prePhotoshootCount++;
    }
  }
  if(prePhotoshootCount == 0) {
    result.add(ResponsesListItem(
        itemType: ResponsesListItem.NO_SAVED_RESPONSES,
        groupName: Response.GROUP_TITLE_PRE_PHOTOSHOOT
    ));
  }

  //Add post photoshoot items
  result.add(ResponsesListItem(
      itemType: ResponsesListItem.GROUP_TITLE,
      title: Response.GROUP_TITLE_POST_PHOTOSHOOT
  ));
  int postPhotoshootCount = 0;
  for(ResponsesListItem response in postPhotoshootResponses) {
    if(response.response.message != null && response.response.message.isNotEmpty) {
      result.add(response);
      postPhotoshootCount++;
    }
  }
  if(postPhotoshootCount == 0) {
    result.add(ResponsesListItem(
        itemType: ResponsesListItem.NO_SAVED_RESPONSES,
        groupName: Response.GROUP_TITLE_POST_PHOTOSHOOT
    ));
  }

  return previousState.copyWith(
    items: result,
    showNoSavedResponsesError: (preBookingCount + prePhotoshootCount + postPhotoshootCount) == 0,
  );
}