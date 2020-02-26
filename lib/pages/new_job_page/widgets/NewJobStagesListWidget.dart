import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewJobStagesListWidget extends StatelessWidget {
  final int index;

  NewJobStagesListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    List<String> jobStageIcons = ImageUtil.jobStageIcons;
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          new FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
            ),
        onPressed: () {
              if(index != 0){
                pageState.onJobStageSelected(
                    JobStage(
                      stage: JobStage.getStageFromIcon(jobStageIcons.elementAt(index)),
                      value: JobStage.getStageValue(JobStage.getStageFromIcon(jobStageIcons.elementAt(index))),
                    ));
              }
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(jobStageIcons.elementAt(index)),
                  fit: BoxFit.contain,
                ),
                color: Color(ColorConstants.getPeachLight()),
                borderRadius: BorderRadius.all(Radius.circular(22.0)),
              ),
              child: !JobStage.containsJobStageIcon(pageState.selectedJobStages, jobStageIcons.elementAt(index)) ? Container(
                decoration: new BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                ),
              ) : SizedBox(),
            ),
            Expanded(
              child: Container(
                height: 64.0,
                margin: EdgeInsets.only(right: 32.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ImageUtil.getJobStageText(jobStageIcons.elementAt(index)),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: JobStage.containsJobStageIcon(pageState.selectedJobStages, jobStageIcons.elementAt(index)) || index == 0 ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.primary_black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            JobStage.containsJobStageIcon(pageState.selectedJobStages, jobStageIcons.elementAt(index)) || index == 0 ? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 24.0,
              width: 24.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageUtil.getJobStageCompleteIconBlack(),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
