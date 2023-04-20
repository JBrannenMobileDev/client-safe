
class Code {

  String id;
  String uid;

  Code({
    this.id,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'uid' : uid,
    };
  }

  static Code fromMap(Map<String, dynamic> map) {
    return Code(
      id: map['id'],
      uid: map['uid'],
    );
  }
}