import 'package:dandylight/models/Response.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageState.dart';

import '../../models/ResponsesListItem.dart';

class FetchResponsesAction{
  final ResponsesPageState? pageState;
  FetchResponsesAction(this.pageState);
}

class SetResponsesAction{
  final ResponsesPageState? pageState;
  final List<Response>? responses;
  SetResponsesAction(this.pageState, this.responses);
}

class UpdateNewCategoryName{
  final ResponsesPageState? pageState;
  final String? name;
  UpdateNewCategoryName(this.pageState, this.name);
}

class UpdateResponseAction{
  final ResponsesPageState? pageState;
  final ResponsesListItem? responseItem;
  UpdateResponseAction(this.pageState, this.responseItem);
}

class SaveNewResponseAction{
  final ResponsesPageState? pageState;
  final Response? response;
  SaveNewResponseAction(this.pageState, this.response);
}

class UpdateEditStateAction {
  final ResponsesPageState? pageState;
  UpdateEditStateAction(this.pageState);
}

class DeleteResponseAction {
  final ResponsesPageState? pageState;
  final ResponsesListItem? item;
  DeleteResponseAction(this.pageState, this.item);
}
