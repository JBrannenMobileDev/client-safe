import 'Pose.dart';

class PoseLibraryGroup {
  int? id;
  String? documentId;
  String? groupName;
  int? numOfSaves;
  List<Pose>? poses;

  PoseLibraryGroup({
    this.id,
    this.documentId,
    this.groupName,
    this.poses,
    this.numOfSaves,
  });

  void sort() {
    List<Pose> newPoses = [];
    List<Pose> oldPoses = [];

    if(poses != null) {
      for(Pose pose in poses!) {
        if(pose.isNewPose()){
          newPoses.add(pose);
        } else {
          oldPoses.add(pose);
        }
      }

      oldPoses.sort((a, b) => b.numOfSaves!.compareTo(a.numOfSaves!) == 0 ? b.createDate!.compareTo(a.createDate!) : b.numOfSaves!.compareTo(a.numOfSaves!));
      newPoses.sort((a, b) => b.numOfSaves!.compareTo(a.numOfSaves!) == 0 ? b.createDate!.compareTo(a.createDate!) : b.numOfSaves!.compareTo(a.numOfSaves!));
      poses = newPoses + oldPoses;
    } else {
      poses = [];
    }
  }

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

  List<Map<String, dynamic>> convertPosesToMap(List<Pose>? poses){
    List<Map<String, dynamic>> listOfMaps = [];
    for(Pose pose in poses != null ? poses : []){
      listOfMaps.add(pose.toMap());
    }
    return listOfMaps;
  }

  static List<Pose> convertMapsToPoses(List? listOfMaps){
    List<Pose> listOfPoses = [];
    for(Map map in listOfMaps != null ? listOfMaps : []){
      listOfPoses.add(Pose.fromMap(map as Map<String, dynamic>));
    }
    return listOfPoses;
  }
}