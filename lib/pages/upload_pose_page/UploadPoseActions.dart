import 'package:image_picker/image_picker.dart';

import 'UploadPosePageState.dart';

class SubmitUploadedPoseAction{
  final UploadPosePageState pageState;
  final XFile poseImage;
  final String name;
  final String url;
  final List<String> tags;
  SubmitUploadedPoseAction(this.pageState, this.poseImage, this.name, this.url, this.tags);
}

