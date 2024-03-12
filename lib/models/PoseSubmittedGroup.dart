import 'Pose.dart';

class PoseSubmittedGroup {
  int? id;
  bool? needsReview;
  String? uid;
  List<Pose>? poses;

  PoseSubmittedGroup({
    this.id,
    this.needsReview,
    this.uid,
    this.poses,
  });

  Map<String, dynamic> toMap() {
    return {
      'needsReview' : needsReview,
      'uid' : uid,
      'poses' : convertPosesToMap(poses!),
    };
  }

  static PoseSubmittedGroup fromMap(Map<String, dynamic> map) {
    return PoseSubmittedGroup(
      needsReview: map['needsReview'],
      uid: map['uid'],
      poses: convertMapsToPoses(map['poses']),
    );
  }

  List<Map<String, dynamic>> convertPosesToMap(List<Pose> poses){
    List<Map<String, dynamic>> listOfMaps = [];
    for(Pose pose in poses != null ? poses : []){
      listOfMaps.add(pose.toMap());
    }
    return listOfMaps;
  }

  static List<Pose> convertMapsToPoses(List listOfMaps){
    List<Pose> listOfPoses = [];
    for(Map map in listOfMaps != null ? listOfMaps : []){
      listOfPoses.add(Pose.fromMap(map as Map<String, dynamic>));
    }
    return listOfPoses;
  }
}