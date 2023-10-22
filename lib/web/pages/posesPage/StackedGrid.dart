import 'package:dandylight/models/Pose.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/DeviceType.dart';

class StackedGrid extends StatelessWidget {
  final List<Pose> poses;
  final double GRID_PADDING = 16;
  
  StackedGrid({this.poses});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: buildColumns(poses, context),
    );
  }

  List<Widget> buildColumns(List<Pose> poses, BuildContext context) {
    List<Widget> result = [];
    List<Widget> column1Items = [];
    List<Widget> column2Items = [];
    List<Widget> column3Items = [];
    List<Widget> column4Items = [];

    int columnNum = 1;
    poses.forEach((pose) {
      if(DeviceType.getDeviceTypeByContext(context) == Type.Website) {
        switch(columnNum) {
          case 1:
            column1Items.add(roundedImage(pose, context));
            break;
          case 2:
            column2Items.add(roundedImage(pose, context));
            break;
          case 3:
            column3Items.add(roundedImage(pose, context));
            break;
          case 4:
            column4Items.add(roundedImage(pose, context));
            break;
        }
        if(columnNum == 4) {
          columnNum = 1;
        } else {
          columnNum++;
        }
      } else {
        switch(columnNum) {
          case 1:
            column1Items.add(roundedImage(pose, context));
            break;
          case 2:
            column2Items.add(roundedImage(pose, context));
            break;
        }
        if(columnNum == 2) {
          columnNum = 1;
        } else {
          columnNum++;
        }
      }
    });

    if(DeviceType.getDeviceTypeByContext(context) == Type.Website) {
      result = [
        Padding(
          padding: EdgeInsets.only(right: GRID_PADDING),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: column1Items,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: GRID_PADDING/2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: column2Items,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: GRID_PADDING/2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: column3Items,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: GRID_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: column4Items,
          ),
        ),
      ];
    } else {
      result = [
        Padding(
          padding: EdgeInsets.only(right: GRID_PADDING/2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: column1Items,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: GRID_PADDING/2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: column2Items,
          ),
        ),
      ];
    }
    return result;
  }

  Widget roundedImage(Pose pose, BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.only(bottom: GRID_PADDING),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Image border
          child: Container(
            width: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : 2.25),
            child: Image.network(
                pose.imageUrl,
                fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  double getPageWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(width >= 1440) return 1440;
    return width;
  }
}