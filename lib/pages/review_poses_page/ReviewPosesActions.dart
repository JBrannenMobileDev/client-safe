import 'package:image_picker/image_picker.dart';

import '../../models/Pose.dart';
import 'ReviewPosesPageState.dart';

class ClearStateAction {
  final ReviewPosesPageState pageState;
  ClearStateAction(this.pageState);
}

class ApprovePoseAction {
  final ReviewPosesPageState pageState;
  final Pose pose;
  ApprovePoseAction(this.pageState, this.pose);
}

class RejectPoseAction {
  final ReviewPosesPageState pageState;
  final Pose pose;
  RejectPoseAction(this.pageState, this.pose);
}

