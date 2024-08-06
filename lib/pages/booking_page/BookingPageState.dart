import 'package:dandylight/AppState.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/SessionType.dart';
import 'BookingPageActions.dart';


class BookingPageState {
  final String? bookingLink;
  final String? newOfferingDescription;
  final bool? setupComplete;
  final bool? bookByInquiry;
  final bool? instantBooking;
  final bool? requireDeposit;
  final List<SessionType>? sessionTypes;
  final SessionType? selectedSessionType;
  final Function(String)? onOfferingDescriptionChanged;
  final Function(SessionType)? onSessionTypeSelected;
  final Function(bool)? onInquiryChanged;
  final Function(bool)? onInstantChanged;
  final Function(bool)? onRequiredChanged;

  BookingPageState({
    @required this.setupComplete,
    @required this.bookingLink,
    @required this.onOfferingDescriptionChanged,
    @required this.selectedSessionType,
    @required this.sessionTypes,
    @required this.onSessionTypeSelected,
    @required this.newOfferingDescription,
    @required this.bookByInquiry,
    @required this.instantBooking,
    @required this.requireDeposit,
    @required this.onInquiryChanged,
    @required this.onInstantChanged,
    @required this.onRequiredChanged,
  });

  BookingPageState copyWith({
    String? bookingLink,
    String? newOfferingDescription,
    bool? setupComplete,
    bool? bookByInquiry,
    bool? instantBooking,
    bool? requireDeposit,
    List<SessionType>? sessionTypes,
    SessionType? selectedSessionType,
    Function(String)? onOfferingDescriptionChanged,
    Function(SessionType)? onSessionTypeSelected,
    Function(bool)? onInquiryChanged,
    Function(bool)? onInstantChanged,
    Function(bool)? onRequiredChanged,
  }){
    return BookingPageState(
      setupComplete: setupComplete ?? this.setupComplete,
      bookingLink: bookingLink ?? this.bookingLink,
      onOfferingDescriptionChanged: onOfferingDescriptionChanged ?? this.onOfferingDescriptionChanged,
      selectedSessionType: selectedSessionType ?? this.selectedSessionType,
      sessionTypes: sessionTypes ?? this.sessionTypes,
      onSessionTypeSelected: onSessionTypeSelected ?? this.onSessionTypeSelected,
      newOfferingDescription: newOfferingDescription ?? this.newOfferingDescription,
      bookByInquiry: bookByInquiry ?? this.bookByInquiry,
      instantBooking: instantBooking ?? this.instantBooking,
      requireDeposit: requireDeposit ?? this.requireDeposit,
      onInquiryChanged: onInquiryChanged ?? this.onInquiryChanged,
      onInstantChanged: onInstantChanged ?? this.onInstantChanged,
      onRequiredChanged: onRequiredChanged ?? this.onRequiredChanged,
    );
  }

  factory BookingPageState.initial() => BookingPageState(
    setupComplete: false,
    bookingLink: '',
    onOfferingDescriptionChanged: null,
    selectedSessionType: null,
    sessionTypes: [],
    onSessionTypeSelected: null,
    newOfferingDescription: '',
    bookByInquiry: true,
    instantBooking: true,
    requireDeposit: false,
    onInquiryChanged: null,
    onInstantChanged: null,
    onRequiredChanged: null,
  );

  factory BookingPageState.fromStore(Store<AppState> store) {
    return BookingPageState(
      setupComplete: store.state.bookingPageState!.setupComplete,
      bookingLink: store.state.bookingPageState!.bookingLink,
      selectedSessionType: store.state.bookingPageState!.selectedSessionType,
      sessionTypes: store.state.bookingPageState!.sessionTypes,
      newOfferingDescription: store.state.bookingPageState!.newOfferingDescription,
      bookByInquiry: store.state.bookingPageState!.bookByInquiry,
      instantBooking: store.state.bookingPageState!.instantBooking,
      requireDeposit: store.state.bookingPageState!.requireDeposit,
      onOfferingDescriptionChanged: (description) => store.dispatch(SetOfferingDescriptionAction(store.state.bookingPageState, description)),
      onSessionTypeSelected: (sessionType) => store.dispatch(SetSelectedSessionTypeAction(store.state.bookingPageState, sessionType)),
      onInquiryChanged: (selected) => store.dispatch(SetBookByInquirySelectionAction(store.state.bookingPageState, selected)),
      onInstantChanged: (selected) => store.dispatch(SetInstantBookingSelectionAction(store.state.bookingPageState, selected)),
      onRequiredChanged: (selected) => store.dispatch(SetRequireDepositSelectionAction(store.state.bookingPageState, selected)),
    );
  }

  @override
  int get hashCode =>
    bookingLink.hashCode ^
    onOfferingDescriptionChanged.hashCode ^
    selectedSessionType.hashCode ^
    sessionTypes.hashCode ^
    newOfferingDescription.hashCode ^
    onSessionTypeSelected.hashCode ^
    bookByInquiry.hashCode ^
    instantBooking.hashCode ^
    requireDeposit.hashCode ^
    onInquiryChanged.hashCode ^
    onInstantChanged.hashCode ^
    onRequiredChanged.hashCode ^
    setupComplete.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingPageState &&
          bookingLink == other.bookingLink &&
          onOfferingDescriptionChanged == other.onOfferingDescriptionChanged &&
          selectedSessionType == other.selectedSessionType &&
          sessionTypes == other.sessionTypes &&
          onSessionTypeSelected == other.onSessionTypeSelected &&
          newOfferingDescription == other.newOfferingDescription &&
          bookByInquiry == other.bookByInquiry &&
          instantBooking == other.instantBooking &&
          requireDeposit == other.requireDeposit &&
          onInquiryChanged == other.onInquiryChanged &&
          onInstantChanged == other.onInstantChanged &&
          onRequiredChanged == other.onRequiredChanged &&
          setupComplete == other.setupComplete;
}
