import 'package:dandylight/utils/UidUtil.dart';

class Pose{
  static const String STATUS_SUBMITTED = 'Submitted';
  static const String STATUS_FEATURED = 'Featured';
  static const String STATUS_REVIEWED = 'Reviewed';
  static const String STATUS_NOT_A_SUBMISSION = 'not_a_submission';

  int id;
  String documentId;
  String uid = '';
  String imageUrl;
  String instagramUrl;
  String instagramName;
  String prompt = '';
  String reviewStatus = STATUS_NOT_A_SUBMISSION;
  int numOfSaves;
  List<String> tags;
  List<String> categories = [];
  DateTime createDate;

  Pose({
    this.id,
    this.uid,
    this.documentId,
    this.imageUrl,
    this.instagramUrl,
    this.instagramName,
    this.numOfSaves,
    this.tags,
    this.createDate,
    this.categories,
    this.prompt,
  });

  bool isMySubmission() {
    return uid == UidUtil().getUid() && reviewStatus == STATUS_NOT_A_SUBMISSION;
  }

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
      'uid' : uid ?? '',
      'imageUrl' : imageUrl,
      'instagramUrl' : instagramUrl,
      'instagramName' : instagramName,
      'prompt' : prompt,
      'categories' : categories,
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
      uid: map['uid'] != null ? map['uid'] : '',
      prompt: map['prompt'] != null ? map['prompt'] : '',
      categories: map['categories'] != null ? List<String>.from(map['categories']) : [],
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      numOfSaves: map['numOfSaves'] != null ? map['numOfSaves'] : 0,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate']) : null,
    );
  }
}