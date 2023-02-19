import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:image_picker/image_picker.dart';

import '../pose_group_page/GroupImage.dart';
import 'LibraryPoseGroupPageState.dart';

class SaveLibraryPosesToGroupAction{
  final LibraryPoseGroupPageState pageState;
  final List<XFile> poseImages;
  SaveLibraryPosesToGroupAction(this.pageState, this.poseImages);
}

class SetLibraryPoseGroupData{
  final LibraryPoseGroupPageState pageState;
  final PoseLibraryGroup poseGroup;
  SetLibraryPoseGroupData(this.pageState, this.poseGroup);
}

class LoadLibraryPoseImagesFromStorage{
  final LibraryPoseGroupPageState pageState;
  final PoseLibraryGroup poseGroup;
  LoadLibraryPoseImagesFromStorage(this.pageState, this.poseGroup);
}

class SetLibraryPoseImagesToState{
  final LibraryPoseGroupPageState pageState;
  final List<GroupImage> poseImages;
  SetLibraryPoseImagesToState(this.pageState, this.poseImages);
}

class ClearLibraryPoseGroupState{
  final LibraryPoseGroupPageState pageState;
  ClearLibraryPoseGroupState(this.pageState);
}

class SetLoadingNewLibraryImagesState{
  final LibraryPoseGroupPageState pageState;
  final bool isLoading;
  SetLoadingNewLibraryImagesState(this.pageState, this.isLoading);
}

class SetIsAdminLibraryAction {
  final LibraryPoseGroupPageState pageState;
  final bool isAdmin;
  SetIsAdminLibraryAction(this.pageState, this.isAdmin);
}

