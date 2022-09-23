class Pose {
  int id;
  String documentId;

  Pose({
    this.id,
    this.documentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
    };
  }

  static Pose fromMap(Map<String, dynamic> map) {
    return Pose(
      documentId: map['documentId'],
    );
  }
}