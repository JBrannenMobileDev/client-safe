import 'package:dandylight/utils/UidUtil.dart';

class Pose implements Comparable<Pose>{
  static const String STATUS_SUBMITTED = 'Submitted';
  static const String STATUS_FEATURED = 'Featured';
  static const String STATUS_REVIEWED = 'Submitted ';
  static const String STATUS_NOT_A_SUBMISSION = 'Not a submission';

  int id;
  String documentId;
  String uid = '';
  String imageUrl;
  String instagramUrl;
  String instagramName;
  String prompt = '';
  String reviewStatus = STATUS_NOT_A_SUBMISSION;
  bool hasSeen = false; //This tracks if they have seen the featured pose that they submitted so that we do not show it in the notifications.
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
    this.reviewStatus,
    this.hasSeen,
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
      'reviewStatus' : reviewStatus != null ? reviewStatus : STATUS_NOT_A_SUBMISSION,
      'categories' : categories,
      'numOfSaves' : numOfSaves != null ? numOfSaves : 0,
      'tags' : tags,
      'hasSeen' : hasSeen,
      'createDate' : createDate?.millisecondsSinceEpoch ?? null,
    };
  }

  static Pose fromMap(Map<String, dynamic> map) {
    return Pose(
      documentId: map['documentId'],
      imageUrl: map['imageUrl'],
      instagramUrl: map['instagramUrl'],
      instagramName: map['instagramName'],
      reviewStatus: map['reviewStatus'] != null ? map['reviewStatus'] : STATUS_NOT_A_SUBMISSION,
      uid: map['uid'] != null ? map['uid'] : '',
      prompt: map['prompt'] != null ? map['prompt'] : '',
      categories: map['categories'] != null ? List<String>.from(map['categories']) : [],
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      numOfSaves: map['numOfSaves'] != null ? map['numOfSaves'] : 0,
      hasSeen: map['hasSeen'] != null ? map['hasSeen'] : false,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate']) : null,
    );
  }

  bool isUnseenFeaturedPose() {
    return reviewStatus == STATUS_FEATURED && !hasSeen;
  }


  /// Desired relation | Result
  /// -------------------------------------------
  ///           a < b  | Returns a negative value.
  ///           a == b | Returns 0.
  ///           a > b  | Returns a positive value.
  ///
  @override
  int compareTo(Pose other) {
    if(this.createDate.isAtSameMomentAs(other.createDate)) return 0;
    return this.createDate.isBefore(other.createDate) ? -1 : 1;
  }
}