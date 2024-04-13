import 'package:image_picker/image_picker.dart';

import 'UploadPosePageState.dart';

class SubmitUploadedPoseAction{
  final UploadPosePageState? pageState;
  final XFile? poseImage500;
  final String? name;
  final String? prompt;
  final List<String>? tags;
  final bool? engagementsSelected;
  final bool? familiesSelected;
  final bool? couplesSelected;
  final bool? portraitsSelected;
  final bool? maternitySelected;
  final bool? weddingsSelected;
  final bool? newbornSelected;
  final bool? proposalsSelected;
  final bool? petsSelected;
  SubmitUploadedPoseAction(this.pageState, this.poseImage500, this.name, this.prompt, this.tags, this.engagementsSelected, this.familiesSelected
      ,this.couplesSelected, this.portraitsSelected, this.maternitySelected, this.weddingsSelected, this.newbornSelected, this.proposalsSelected, this.petsSelected);
}

class ResizeImageAction {
  final UploadPosePageState? pageState;
  final XFile? image;
  ResizeImageAction(this.pageState, this.image);
}

class SetResizedImageAction {
  final UploadPosePageState? pageState;
  final XFile? resizedImage500;
  SetResizedImageAction(this.pageState, this.resizedImage500);
}

class SetInstagramNameAction {
  final UploadPosePageState? pageState;
  final String? instagramName;
  SetInstagramNameAction(this.pageState, this.instagramName);
}

class ClearStateAction {
  final UploadPosePageState? pageState;
  ClearStateAction(this.pageState);
}

