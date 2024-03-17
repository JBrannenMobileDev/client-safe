
import 'package:image_picker/image_picker.dart';

import '../../models/PoseGroup.dart';
import 'NewPoseGroupPageState.dart';

class SaveAction{
  final NewPoseGroupPageState? pageState;
  SaveAction(this.pageState);
}

class UpdateName{
  final NewPoseGroupPageState? pageState;
  final String? groupName;
  UpdateName(this.pageState, this.groupName);
}

class ClearStateAction{
  final NewPoseGroupPageState? pageState;
  ClearStateAction(this.pageState);
}

