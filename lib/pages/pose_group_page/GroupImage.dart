import 'package:image_picker/image_picker.dart';

import '../../models/Pose.dart';

class GroupImage implements Comparable<GroupImage>{
  final XFile? file;
  final Pose? pose;

  GroupImage({this.file, this.pose});

  /// Desired relation | Result
  /// -------------------------------------------
  ///           a < b  | Returns a negative value.
  ///           a == b | Returns 0.
  ///           a > b  | Returns a positive value.
  ///
  @override
  int compareTo(GroupImage other) {
    if(this.pose!.createDate!.isAtSameMomentAs(other.pose!.createDate!)) return 0;
    return this.pose!.createDate!.isBefore(other.pose!.createDate!) ? 1 : -1;
  }
}