class Action{
  String title;
  String description;
  ActionType type;

  Action(this.title, this.description, this.type);

}

enum ActionType{
  birthday,
  anniversary,
  graduation,
  pregnancy_3rd_trimester,
  mothers_day,
  valentines_day,
  fathers_day,
  christmas,
  other
}