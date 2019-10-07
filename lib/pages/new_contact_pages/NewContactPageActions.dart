import 'package:client_safe/models/ImportantDate.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';


class ClearStateAction{
  final NewContactPageState pageState;
  ClearStateAction(this.pageState);
}

class UpdateNewContactFirstNameAction{
  final NewContactPageState pageState;
  final String firstName;
  UpdateNewContactFirstNameAction(this.pageState, this.firstName);
}

class UpdateNewContactLastNameAction{
  final NewContactPageState pageState;
  final String lastName;
  UpdateNewContactLastNameAction(this.pageState, this.lastName);
}

class UpdateGenderSelectionAction{
  final NewContactPageState pageState;
  final int genderIndex;
  UpdateGenderSelectionAction(this.pageState, this.genderIndex);
}

class UpdatePhoneNumAction{
  final NewContactPageState pageState;
  final String phone;
  UpdatePhoneNumAction(this.pageState, this.phone);
}

class UpdateEmailAction{
  final NewContactPageState pageState;
  final String email;
  UpdateEmailAction(this.pageState, this.email);
}

class UpdateInstagramUrlAction{
  final NewContactPageState pageState;
  final String instaUrl;
  UpdateInstagramUrlAction(this.pageState, this.instaUrl);
}

class UpdateRelationshipAction{
  final NewContactPageState pageState;
  final int statusIndex;
  UpdateRelationshipAction(this.pageState, this.statusIndex);
}

class UpdateSpouseFirstNameAction{
  final NewContactPageState pageState;
  final String firstName;
  UpdateSpouseFirstNameAction(this.pageState, this.firstName);
}

class UpdateSpouseLastNameAction{
  final NewContactPageState pageState;
  final String lastName;
  UpdateSpouseLastNameAction(this.pageState, this.lastName);
}

class UpdateNumOfChildrenAction{
  final NewContactPageState pageState;
  final int childCount;
  UpdateNumOfChildrenAction(this.pageState, this.childCount);
}

class AddImportantDateAction{
  final NewContactPageState pageState;
  final ImportantDate importantDate;
  AddImportantDateAction(this.pageState, this.importantDate);
}

class RemoveImportantDateAction{
  final NewContactPageState pageState;
  final int chipIndex;
  RemoveImportantDateAction(this.pageState, this.chipIndex);
}

class UpdateNotesAction{
  final NewContactPageState pageState;
  final String notes;
  UpdateNotesAction(this.pageState, this.notes);
}


