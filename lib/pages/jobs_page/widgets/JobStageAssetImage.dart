import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JobStateAssetImage extends StatelessWidget{
  final String stage;
  final bool enabled;
  final bool completed;
  final bool isCurrentStage;

  JobStateAssetImage(this.stage, this.enabled, this.completed, this.isCurrentStage);

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: !enabled ? BoxDecoration(
        color: Colors.grey,
        backgroundBlendMode:BlendMode.saturation,
      ) : BoxDecoration(),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            height: 32.0,
            width: 32.0,
            decoration: BoxDecoration(
              image: completed ? DecorationImage(
                image: AssetImage(stage),
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(.50), BlendMode.dstATop),
              ) : !enabled ? DecorationImage(
                image: AssetImage(stage),
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(.25), BlendMode.dstATop),
              ) : DecorationImage(
                image: AssetImage(stage),
                fit: BoxFit.contain,
              ),
            ),
          ),
          completed ? Container(
            margin: EdgeInsets.only(right: 8.0),
            height: 16.0,
            width: 16.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: JobStage.getStageImageStatic(stage),
                fit: BoxFit.contain,
              ),
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}