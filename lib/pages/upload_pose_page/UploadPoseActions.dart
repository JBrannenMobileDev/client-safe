import 'package:image_picker/image_picker.dart';

import 'UploadPosePageState.dart';

class SubmitUploadedPoseAction{
  final UploadPosePageState pageState;
  final XFile poseImage;
  final String name;
  final String prompt;
  final List<String> tags;
  final bool engagementsSelected;
  final bool familiesSelected;
  final bool couplesSelected;
  final bool portraitsSelected;
  final bool maternitySelected;
  final bool weddingsSelected;
  final bool newbornSelected;
  final bool proposalsSelected;
  final bool petsSelected;
  SubmitUploadedPoseAction(this.pageState, this.poseImage, this.name, this.prompt, this.tags, this.engagementsSelected, this.familiesSelected
      ,this.couplesSelected, this.portraitsSelected, this.maternitySelected, this.weddingsSelected, this.newbornSelected, this.proposalsSelected, this.petsSelected);
}

class SetInstagramNameAction {
  final UploadPosePageState pageState;
  final String instagramName;
  SetInstagramNameAction(this.pageState, this.instagramName);
}

class ClearStateAction {
  final UploadPosePageState pageState;
  ClearStateAction(this.pageState);
}

