import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class ClientDetailsPageState {
  final Client client;
  final List<Job> clientJobs;
  final Function(Client) onEditClientClicked;
  final Function() onDeleteClientClicked;
  final Function() onCallClientClicked;
  final Function() onMessageClientClicked;
  final Function() onEmailClientClicked;
  final Function(Client) onStartNewJobClicked;
  final Function(Job) onJobSelected;
  final Function() onInstagramSelected;

  ClientDetailsPageState({
    @required this.client,
    @required this.clientJobs,
    @required this.onEditClientClicked,
    @required this.onDeleteClientClicked,
    @required this.onCallClientClicked,
    @required this.onMessageClientClicked,
    @required this.onEmailClientClicked,
    @required this.onStartNewJobClicked,
    @required this.onJobSelected,
    @required this.onInstagramSelected,
  });

  ClientDetailsPageState copyWith({
    Client client,
    List<Job> clientJobs,
    Function(Client) onEditClientClicked,
    Function() onDeleteClientClicked,
    Function() onCallClientClicked,
    Function() onMessageClientClicked,
    Function() onEmailClientClicked,
    Function(Client) onStartNewJobClicked,
    Function(Job) onJobSelected,
    Function() onInstagramSelected,
  }){
    return ClientDetailsPageState(
      client: client?? this.client,
      clientJobs: clientJobs?? this.clientJobs,
      onEditClientClicked: onEditClientClicked?? this.onEditClientClicked,
      onDeleteClientClicked: onDeleteClientClicked?? this.onDeleteClientClicked,
      onCallClientClicked: onCallClientClicked?? this.onCallClientClicked,
      onMessageClientClicked: onMessageClientClicked?? this.onMessageClientClicked,
      onEmailClientClicked: onEmailClientClicked?? this.onEmailClientClicked,
      onStartNewJobClicked: onStartNewJobClicked?? this.onStartNewJobClicked,
      onJobSelected: onJobSelected?? this.onJobSelected,
      onInstagramSelected: onInstagramSelected?? this.onInstagramSelected,
    );
  }

  factory ClientDetailsPageState.initial() => ClientDetailsPageState(
    client: null,
    clientJobs: List(),
    onEditClientClicked: null,
    onDeleteClientClicked: null,
    onCallClientClicked: null,
    onMessageClientClicked: null,
    onEmailClientClicked: null,
    onStartNewJobClicked: null,
    onJobSelected: null,
    onInstagramSelected: null,
  );

  factory ClientDetailsPageState.fromStore(Store<AppState> store) {
    return ClientDetailsPageState(
      client: store.state.clientDetailsPageState.client,
      clientJobs: store.state.clientDetailsPageState.clientJobs,
      onEditClientClicked: (client) => store.dispatch(LoadExistingClientData(store.state.newContactPageState, client)),
      onDeleteClientClicked: () => store.dispatch(DeleteClientAction(store.state.clientDetailsPageState)),
      onCallClientClicked: () => store.dispatch(null),
      onMessageClientClicked: () => store.dispatch(null),
      onEmailClientClicked: () => store.dispatch(null),
      onStartNewJobClicked: (client) => store.dispatch(InitializeNewContactPageAction(store.state.newJobPageState, client)),
      onJobSelected: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
      onInstagramSelected: () => store.dispatch(InstagramSelectedAction(store.state.clientDetailsPageState)),
    );
  }

  @override
  int get hashCode =>
    client.hashCode ^
    clientJobs.hashCode ^
    onEditClientClicked.hashCode ^
    onCallClientClicked.hashCode ^
    onDeleteClientClicked.hashCode ^
    onMessageClientClicked.hashCode ^
    onEmailClientClicked.hashCode ^
    onStartNewJobClicked.hashCode ^
    onJobSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientDetailsPageState &&
          client == other.client &&
          clientJobs == other.clientJobs &&
          onEditClientClicked == other.onEditClientClicked &&
          onDeleteClientClicked == other.onDeleteClientClicked &&
          onCallClientClicked == other.onCallClientClicked &&
          onMessageClientClicked == other.onMessageClientClicked &&
          onEmailClientClicked == other.onEmailClientClicked &&
          onStartNewJobClicked == other.onStartNewJobClicked &&
          onJobSelected == other.onJobSelected;
}
