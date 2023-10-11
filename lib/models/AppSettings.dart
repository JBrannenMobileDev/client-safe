class AppSettings {
  int id;
  String documentId;
  String currentBuildVersionNumber;
  bool show;

  AppSettings({
    this.id,
    this.documentId,
    this.currentBuildVersionNumber,
    this.show,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'currentBuildVersionNumber': currentBuildVersionNumber,
      'show' : show ?? false,
    };
  }

  static AppSettings fromMap(Map<String, dynamic> map) {
    return AppSettings(
      documentId: map['documentId'],
      currentBuildVersionNumber: map['currentBuildVersionNumber'],
      show: map['show'] != null ? map['show'] : false,
    );
  }
}