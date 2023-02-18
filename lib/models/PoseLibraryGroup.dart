import 'Pose.dart';

class PoseLibraryGroup {
  int id;
  String documentId;
  String groupName;
  List<Pose> poses;

  PoseLibraryGroup({
    this.id,
    this.documentId,
    this.groupName,
    this.poses,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'groupName': groupName,
      'poses' : convertPosesToMap(poses),
    };
  }

  static PoseLibraryGroup fromMap(Map<String, dynamic> map) {
    return PoseLibraryGroup(
      documentId: map['documentId'],
      groupName: map['groupName'],
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
      listOfPoses.add(Pose.fromMap(map));
    }
    return listOfPoses;
  }
}