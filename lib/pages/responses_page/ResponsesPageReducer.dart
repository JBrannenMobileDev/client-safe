import 'package:dandylight/models/ResponsesListItem.dart';
import 'package:dandylight/pages/responses_page/ResponsesActions.dart';
import 'package:redux/redux.dart';

import '../../models/Response.dart';
import 'ResponsesPageState.dart';

final responsesReducer = combineReducers<ResponsesPageState>([
  TypedReducer<ResponsesPageState, SetResponsesAction>(_setResponses),
  TypedReducer<ResponsesPageState, UpdateEditStateAction>(_setEnabledState),
]);

ResponsesPageState _setEnabledState(ResponsesPageState previousState, UpdateEditStateAction action){
  return previousState.copyWith(
    isEditEnabled: !action.pageState!.isEditEnabled!,
  );
}

ResponsesPageState _setResponses(ResponsesPageState previousState, SetResponsesAction action){
  List<ResponsesListItem> result = [];
  List<ResponsesListItem> preBookingResponses = [];
  List<ResponsesListItem> prePhotoshootResponses = [];
  List<ResponsesListItem> postPhotoshootResponses = [];

  for(Response response in action.responses!) {
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
  for(ResponsesListItem response in preBookingResponses) {
    result.add(response);
  }
  result.add(ResponsesListItem(
    itemType: ResponsesListItem.ADD_ANOTHER_BUTTON,
    title: 'Add another',
    groupName: Response.GROUP_TITLE_PRE_BOOKING,
  ));

  //Add pre photoshoot items
  result.add(ResponsesListItem(
      itemType: ResponsesListItem.GROUP_TITLE,
      title: Response.GROUP_TITLE_PRE_PHOTOSHOOT
  ));
  for(ResponsesListItem response in prePhotoshootResponses) {
    result.add(response);
  }
  result.add(ResponsesListItem(
    itemType: ResponsesListItem.ADD_ANOTHER_BUTTON,
    title: 'Add another',
    groupName: Response.GROUP_TITLE_PRE_PHOTOSHOOT,
  ));

  //Add post photoshoot items
  result.add(ResponsesListItem(
      itemType: ResponsesListItem.GROUP_TITLE,
      title: Response.GROUP_TITLE_POST_PHOTOSHOOT
  ));
  for(ResponsesListItem response in postPhotoshootResponses) {
    result.add(response);
  }
  result.add(ResponsesListItem(
    itemType: ResponsesListItem.ADD_ANOTHER_BUTTON,
    title: 'Add another',
    groupName: Response.GROUP_TITLE_POST_PHOTOSHOOT,
  ));

  return previousState.copyWith(
    items: result,
  );
}
