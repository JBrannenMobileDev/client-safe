class Pose{
  int id;
  String documentId;
  String imageUrl;
  String instagramUrl;
  String instagramName;
  int numOfSaves;
  List<String> tags;
  DateTime createDate;

  Pose({
    this.id,
    this.documentId,
    this.imageUrl,
    this.instagramUrl,
    this.instagramName,
    this.numOfSaves,
    this.tags,
    this.createDate,
  });

  bool isLibraryPose() {
    return instagramName != null && instagramName.isNotEmpty && instagramUrl != null && instagramUrl.isNotEmpty && tags != null && tags.isNotEmpty;
  }

  bool isNewPose() {
    if(createDate == null) return false;
    DateTime endNewPoseDate = createDate.add(Duration(days: 14));
    return DateTime.now().isBefore(endNewPoseDate);
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'imageUrl' : imageUrl,
      'instagramUrl' : instagramUrl,
      'instagramName' : instagramName,
      'numOfSaves' : numOfSaves != null ? numOfSaves : 0,
      'tags' : tags,
      'createDate' : createDate?.millisecondsSinceEpoch ?? null,
    };
  }

  static Pose fromMap(Map<String, dynamic> map) {
    return Pose(
      documentId: map['documentId'],
      imageUrl: map['imageUrl'],
      instagramUrl: map['instagramUrl'],
      instagramName: map['instagramName'],
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      numOfSaves: map['numOfSaves'] != null ? map['numOfSaves'] : 0,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate']) : null,
    );
  }
}