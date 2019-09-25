import 'package:client_safe/models/Job.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';

class JobListItem extends StatelessWidget{
  final Job job;
  JobListItem({this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageUtil.getRandomJobIcon(),
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[

            ],
          )
        ],
      ),
    );
  }
}