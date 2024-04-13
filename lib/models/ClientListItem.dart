import 'package:dandylight/models/ListItem.dart';

class ClientListItem implements ListItem {
  final String? name;
  final String? number;
  final DateTime? lastContactedDate;

  ClientListItem(this.name, this.number, this.lastContactedDate);
}