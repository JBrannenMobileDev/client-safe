import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Action.dart';
import 'package:client_safe/models/Client.dart';
import 'package:redux/redux.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class JobsPageState {
  final String accountName;
  final List<Action> actionItems;
  final List<Client> recentClients;
  final Function() onAddNewClientClicked;
  final Function() onSearchClientsClicked;
  final Function(Action) onActionItemClicked;
  final Function(Client) onClientClicked;

  JobsPageState(
      this.accountName,
      this.actionItems,
      this.recentClients,
      this.onAddNewClientClicked,
      this.onSearchClientsClicked,
      this.onActionItemClicked,
      this.onClientClicked,
  );

  factory JobsPageState.initial() => JobsPageState("", new List(), new List(), null, null, null, null,);

  factory JobsPageState.create(Store<AppState> store) {
    return new JobsPageState(
      store.state.homePageState.accountName,
      store.state.homePageState.actionItems,
      store.state.homePageState.recentClients,
//      () => store.dispatch(AddNewClientAction(store.state.homePageState)),
//      () => store.dispatch(SearchAllClientsAction(store.state.homePageState)),
//      (action) => store.dispatch(ActionItemClicked(store.state.accountDetailsState, recentItem)),
//      (client) => store.dispatch(RecentClientCLickedAction(store.state.accountDetailsState, accountItem)),
      () => store.dispatch(null),
      () => store.dispatch(null),
      (action) => store.dispatch(null),
      (client) => store.dispatch(null),
    );
  }

  @override
  int get hashCode =>
    accountName.hashCode ^
    actionItems.hashCode ^
    recentClients.hashCode ^
    onAddNewClientClicked.hashCode ^
    onSearchClientsClicked.hashCode ^
    onActionItemClicked.hashCode ^
    onClientClicked.hashCode
    ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobsPageState &&
          accountName == other.accountName &&
          actionItems == other.actionItems &&
          recentClients == other.recentClients &&
          onAddNewClientClicked == other.onAddNewClientClicked &&
          onSearchClientsClicked == other.onSearchClientsClicked &&
          onActionItemClicked == other.onActionItemClicked &&
          onClientClicked == other.onClientClicked;
}