import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';

class JobType {
  int id;
  String documentId;
  PriceProfile priceProfile;
  DateTime createdDate;
  List<JobStage> stages;

  JobType({
    this.id,
    this.documentId,
    this.priceProfile,
    this.createdDate,
    this.stages,
  });

  JobType copyWith({
    int id,
    String documentId,
    PriceProfile priceProfile,
    DateTime createdDate,
    List<JobStage> stages,
  }){
    return JobType(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      priceProfile: priceProfile ?? this.priceProfile,
      createdDate: createdDate ?? this.createdDate,
      stages: stages ?? this.stages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'createdDate' : createdDate?.toString() ?? "",
      'priceProfile' : priceProfile?.toMap() ?? null,
      'stages' : convertStagesToMap(stages)
    };
  }

  static JobType fromMap(Map<String, dynamic> map) {
    return JobType(
      documentId: map['documentId'],
      createdDate: map['createdDate'],
      priceProfile: map['priceProfile'] != null ? PriceProfile.fromMap(map['priceProfile']) : null,
      stages: convertMapsToJobStages(map['stages']),
    );
  }

  List<Map<String, dynamic>> convertStagesToMap(List<JobStage> Stages){
    List<Map<String, dynamic>> listOfMaps = [];
    for(JobStage jobStage in stages){
      listOfMaps.add(jobStage.toMap());
    }
    return listOfMaps;
  }

  static List<JobStage> convertMapsToJobStages(List listOfMaps){
    List<JobStage> listOfJobStages = [];
    for(Map map in listOfMaps){
      listOfJobStages.add(JobStage.fromMap(map));
    }
    return listOfJobStages;
  }
}