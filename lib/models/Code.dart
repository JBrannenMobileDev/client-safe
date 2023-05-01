
class Code {

  String id;
  String uid;
  String instaUrl;

  Code({
    this.id,
    this.uid,
    this.instaUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'uid' : uid,
      'instaUrl' : instaUrl,
    };
  }

  static Code fromMap(Map<String, dynamic> map) {
    return Code(
      id: map['id'],
      uid: map['uid'],
      instaUrl: map['instaUrl'],
    );
  }
}