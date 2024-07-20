import '../../models/SessionType.dart';
import 'SessionTypesPageState.dart';

class FetchSessionTypesAction{
  final SessionTypesPageState? pageState;
  FetchSessionTypesAction(this.pageState);
}

class SetSessionTypesAction{
  final SessionTypesPageState? pageState;
  final List<SessionType>? sessionTypes;
  SetSessionTypesAction(this.pageState, this.sessionTypes);
}

