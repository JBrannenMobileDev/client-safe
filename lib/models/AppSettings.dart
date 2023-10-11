class AppSettings {
  int id;
  String documentId;
  String currentBuildVersionNumber;
  String updateTitle;
  String updateMessage;
  bool show;

  AppSettings({
    this.id,
    this.documentId,
    this.currentBuildVersionNumber,
    this.show,
    this.updateTitle,
    this.updateMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'currentBuildVersionNumber': currentBuildVersionNumber,
      'show' : show ?? false,
      'updateTitle' : updateTitle,
      'updateMessage' : updateMessage,
    };
  }

  static AppSettings fromMap(Map<String, dynamic> map) {
    return AppSettings(
      documentId: map['documentId'],
      currentBuildVersionNumber: map['currentBuildVersionNumber'],
      show: map['show'] != null ? map['show'] : false,
      updateTitle: map['updateTitle'] != null ? map['updateTitle'] : 'Update Available',
      updateMessage: map['updateMessage'] != null ? map['updateMessage'] : 'Please update your app to get access to the latest changes.',
    );
  }
}