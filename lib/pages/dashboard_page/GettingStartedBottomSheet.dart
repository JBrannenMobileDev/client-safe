import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_store/open_store.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'DashboardPageState.dart';


class GettingStartedBottomSheet extends StatefulWidget {
  const GettingStartedBottomSheet({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _GettingStartedBottomSheetState();
  }
}

class _GettingStartedBottomSheetState extends State<GettingStartedBottomSheet> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Container(
           height: MediaQuery.of(context).size.height - 116,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
             child: Column(
               children: [
                  TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Getting Started Progress',
                  ),
                 TextDandyLight(
                   type: TextDandyLight.LARGE_TEXT,
                   text: '${pageState.profile?.progress.getProgressValue().toStringAsFixed(0) ?? '0'}% Complete',
                   color: ((pageState.profile?.progress.getProgressString()) == '100') ? Color(ColorConstants.getBlueDark()) : Color(ColorConstants.getPeachDark()),
                 ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 32),
                          alignment: Alignment.centerLeft,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Step 1 - Looking professional',
                            textAlign: TextAlign.start,
                            isBold: true,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          height: 84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/icons/checkbox_empty.png', color: Color(ColorConstants.getPrimaryGreyMedium()), height: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Preview Client Portal',
                                      textAlign: TextAlign.start,
                                      isBold: true,
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'The Client Portal is a branded website that is made specific for each job. This will be a place to share all job details and documents.',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/icons/checkbox_empty.png', color: Color(ColorConstants.getPrimaryGreyMedium()), height: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Setup your brand',
                                      textAlign: TextAlign.start,
                                      isBold: true,
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'Your brand will be used to style your client portal along with any documents you add to your job.',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 32),
                          alignment: Alignment.centerLeft,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Step 2 - Create your first job',
                            textAlign: TextAlign.start,
                            isBold: true,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          height: 84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/icons/checkbox_empty.png', color: Color(ColorConstants.getPrimaryGreyMedium()), height: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Create a Job Type',
                                      textAlign: TextAlign.start,
                                      isBold: true,
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'The Client Portal is a branded website that is made specific for each job. This will be a place to share all job details and documents.',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/icons/checkbox_empty.png', color: Color(ColorConstants.getPrimaryGreyMedium()), height: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Create a Price Package',
                                      textAlign: TextAlign.start,
                                      isBold: true,
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'Your brand will be used to style your client portal along with any documents you add to your job.',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/icons/checkbox_empty.png', color: Color(ColorConstants.getPrimaryGreyMedium()), height: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Add a client',
                                      textAlign: TextAlign.start,
                                      isBold: true,
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'Your brand will be used to style your client portal along with any documents you add to your job.',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/icons/checkbox_empty.png', color: Color(ColorConstants.getPrimaryGreyMedium()), height: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Create a job',
                                      textAlign: TextAlign.start,
                                      isBold: true,
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'Your brand will be used to style your client portal along with any documents you add to your job.',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 32),
                          alignment: Alignment.centerLeft,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Step 3 - Create your first job',
                            textAlign: TextAlign.start,
                            isBold: true,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                        const SizedBox(height: 124)
                      ],
                    ),
                  )
               ],
             ),
         ),
    );
}