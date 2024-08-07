import 'package:contacts_service/contacts_service.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';

class LoadExistingClientData{
  final NewContactPageState? pageState;
  final Client? client;
  LoadExistingClientData(this.pageState, this.client);
}

class UpdateCustomLeadNameAction{
  final NewContactPageState? pageState;
  final String? customName;
  UpdateCustomLeadNameAction(this.pageState, this.customName);
}

class SetSavedClientToState{
  final NewContactPageState? pageState;
  final Client? client;
  SetSavedClientToState(this.pageState, this.client);
}

class FilterDeviceContactsAction{
  final NewContactPageState? pageState;
  final String? textInput;
  FilterDeviceContactsAction(this.pageState, this.textInput);
}

class ClearDeviceContactsAction{
  final NewContactPageState? pageState;
  ClearDeviceContactsAction(this.pageState);
}

class SetSelectedDeviceContactAction{
  final NewContactPageState? pageState;
  final Contact? selectedContact;
  SetSelectedDeviceContactAction(this.pageState, this.selectedContact);
}

class SaveNewContactAction{
  final NewContactPageState? pageState;
  SaveNewContactAction(this.pageState);
}

class GetDeviceContactsAction{
  final NewContactPageState? pageState;
  GetDeviceContactsAction(this.pageState);
}

class LoadDeviceContacts{
  final NewContactPageState? pageState;
  final List<Contact>? deviceContacts;
  LoadDeviceContacts(this.pageState, this.deviceContacts);
}

class UpdateErrorStateAction{
  final NewContactPageState? pageState;
  final String? errorCode;
  UpdateErrorStateAction(this.pageState, this.errorCode);
}

class SetLeadSourceAction{
  final NewContactPageState? pageState;
  final String? leadSource;
  SetLeadSourceAction(this.pageState, this.leadSource);
}

class ClearStateAction{
  final NewContactPageState? pageState;
  ClearStateAction(this.pageState);
}

class SetIsComingFromNewJobAction{
  final NewContactPageState? pageState;
  SetIsComingFromNewJobAction(this.pageState);
}

class UpdateNewContactFirstNameAction{
  final NewContactPageState? pageState;
  final String? firstName;
  UpdateNewContactFirstNameAction(this.pageState, this.firstName);
}

class UpdateNewContactLastNameAction{
  final NewContactPageState? pageState;
  final String? lastName;
  UpdateNewContactLastNameAction(this.pageState, this.lastName);
}

class UpdatePhoneNumAction{
  final NewContactPageState? pageState;
  final String? phone;
  UpdatePhoneNumAction(this.pageState, this.phone);
}

class UpdateEmailAction{
  final NewContactPageState? pageState;
  final String? email;
  UpdateEmailAction(this.pageState, this.email);
}

class UpdateInstagramUrlAction{
  final NewContactPageState? pageState;
  final String? instaUrl;
  UpdateInstagramUrlAction(this.pageState, this.instaUrl);
}

class UpdateRelationshipAction{
  final NewContactPageState? pageState;
  final int? statusIndex;
  UpdateRelationshipAction(this.pageState, this.statusIndex);
}

