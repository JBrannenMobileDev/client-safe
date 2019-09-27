import 'package:client_safe/models/Job.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JobStateAssetImage extends StatelessWidget{
  final String stage;
  final bool enabled;
  final bool completed;

  JobStateAssetImage(this.stage, this.enabled, this.completed);

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: !enabled ? BoxDecoration(
        color: Colors.grey,
        backgroundBlendMode:BlendMode.saturation,
      ) : BoxDecoration(),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            height: 32.0,
            width: 32.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(stage),
                fit: BoxFit.contain,
              ),
            ),
          ),
          completed ? Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: 8.0, top: 8.0),
            height: 16.0,
            width: 16.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Job.JOB_STAGE_COMPLETED_CHECK),
                fit: BoxFit.contain,
              ),
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}