class Suggestion {
  String? message;
  String? userId;
  DateTime? dateSubmitted;

  Suggestion({
    this.message,
    this.userId,
    this.dateSubmitted,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'userId' : userId,
      'dateSubmitted' : dateSubmitted?.toString() ?? ""
    };
  }

  static Suggestion fromMap(Map<String, dynamic> map) {
    return Suggestion(
      message: map['message'],
      userId: map['userId'],
      dateSubmitted: map['dateSubmitted'] != ""? DateTime.parse(map['dateSubmitted']) : null,
    );
  }
}