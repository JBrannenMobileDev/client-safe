import 'package:client_safe/models/Job.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JobListItem extends StatelessWidget{
  final Job job;
  JobListItem({this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 16.0),
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageUtil.getRandomJobIcon(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      job.jobTitle,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    Text(
                      job.clientName + " • " + job.getJobType(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    Text(
                      DateFormat("EEEE, LLLL dd").format(job.dateTime),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ],
                ),
              ),
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