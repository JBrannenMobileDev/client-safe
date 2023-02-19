import 'Pose.dart';

class PoseLibraryGroup {
  int id;
  String documentId;
  String groupName;
  int numOfSaves;
  List<Pose> poses;

  PoseLibraryGroup({
    this.id,
    this.documentId,
    this.groupName,
    this.poses,
    this.numOfSaves,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'groupName': groupName,
      'poses' : convertPosesToMap(poses),
      'numOfSaves' : numOfSaves != null ? numOfSaves : 0,
    };
  }

  static PoseLibraryGroup fromMap(Map<String, dynamic> map) {
    return PoseLibraryGroup(
      documentId: map['documentId'],
      groupName: map['groupName'],
      poses: convertMapsToPoses(map['poses']),
      numOfSaves: map['numOfSaves'],
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