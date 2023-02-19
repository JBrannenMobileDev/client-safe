class Pose {
  int id;
  String documentId;
  String imageUrl;
  String instagramUrl;
  String instagramName;
  int numOfSaves;

  Pose({
    this.id,
    this.documentId,
    this.imageUrl,
    this.instagramUrl,
    this.instagramName,
    this.numOfSaves,
  });

  bool isLibraryPose() {
    return instagramName.isNotEmpty && instagramUrl.isNotEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'imageUrl' : imageUrl,
      'instagramUrl' : instagramUrl,
      'instagramName' : instagramName,
      'numOfSaves' : numOfSaves != null ? numOfSaves : 0,
    };
  }

  static Pose fromMap(Map<String, dynamic> map) {
    return Pose(
      documentId: map['documentId'],
      imageUrl: map['imageUrl'],
      instagramUrl: map['instagramUrl'],
      instagramName: map['instagramName'],
      numOfSaves: map['numOfSaves'] != null ? map['numOfSaves'] : 0,
    );
  }
}