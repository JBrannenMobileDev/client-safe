import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/ImportantDate.dart';
import '../../models/ResponsesListItem.dart';
import 'BookingPageActions.dart';

class BookingPageState {
  final Client? client;
  final List<Job>? clientJobs;
  final String? leadSource;
  final String? customLeadSourceName;
  final String? notes;
  final String? bookingLink;
  final bool? showNoSavedResponsesError;
  final bool? setupComplete;
  final List<ResponsesListItem>? items;
  final List<ImportantDate>? importantDates;

  BookingPageState({
    @required this.client,
    @required this.clientJobs,
    @required this.leadSource,
    @required this.customLeadSourceName,
    @required this.notes,
    @required this.importantDates,
    @required this.items,
    @required this.showNoSavedResponsesError,
    @required this.setupComplete,
    @required this.bookingLink,
  });

  BookingPageState copyWith({
    Client? client,
    List<Job>? clientJobs,
    String? leadSource,
    String? customLeadSourceName,
    String? bookingLink,
    bool? showNoSavedResponsesError,
    String? notes,
    List<ImportantDate>? importantDates,
    List<ResponsesListItem>? items,
    bool? setupComplete,
  }){
    return BookingPageState(
      client: client?? this.client,
      clientJobs: clientJobs?? this.clientJobs,
      leadSource: leadSource ?? this.leadSource,
      customLeadSourceName: customLeadSourceName ?? this.customLeadSourceName,
      notes: notes ?? this.notes,
      importantDates: importantDates ?? this.importantDates,
      items: items ?? this.items,
      showNoSavedResponsesError: showNoSavedResponsesError ?? this.showNoSavedResponsesError,
      setupComplete: setupComplete ?? this.setupComplete,
      bookingLink: bookingLink ?? this.bookingLink,
    );
  }

  factory BookingPageState.initial() => BookingPageState(
    client: null,
    clientJobs: [],
    leadSource: '',
    customLeadSourceName: '',
    notes: '',
    importantDates: [],
    items: [],
    showNoSavedResponsesError: true,
    setupComplete: false,
    bookingLink: '',
  );

  factory BookingPageState.fromStore(Store<AppState> store) {
    return BookingPageState(
      client: store.state.bookingPageState!.client,
      clientJobs: store.state.bookingPageState!.clientJobs,
      leadSource: store.state.bookingPageState!.leadSource,
      customLeadSourceName: store.state.bookingPageState!.customLeadSourceName,
      notes: store.state.bookingPageState!.notes,
      importantDates: store.state.bookingPageState!.importantDates,
      items: store.state.bookingPageState!.items,
      showNoSavedResponsesError: store.state.bookingPageState!.showNoSavedResponsesError,
      setupComplete: store.state.bookingPageState!.setupComplete,
      bookingLink: store.state.bookingPageState!.bookingLink,
    );
  }

  @override
  int get hashCode =>
    client.hashCode ^
    clientJobs.hashCode ^
    leadSource.hashCode ^
    customLeadSourceName.hashCode ^
    notes.hashCode ^
    importantDates.hashCode ^
    bookingLink.hashCode ^
    items.hashCode ^
    showNoSavedResponsesError.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingPageState &&
          client == other.client &&
          clientJobs == other.clientJobs &&
          notes == other.notes &&
          bookingLink == other.bookingLink &&
          importantDates == other.importantDates &&
          items == other.items &&
          showNoSavedResponsesError == other.showNoSavedResponsesError;
}
