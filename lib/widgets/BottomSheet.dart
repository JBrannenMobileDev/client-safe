import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/TextDandyLight.dart';

class BottomSheet extends StatefulWidget {
  final Widget body;
  final bool showPlusIcon;
  final bool showDoneButton;
  final String title;
  final double dialogHeight;
  final Function? plusAction;
  final Function? doneAction;

  const BottomSheet({super.key,
    this.body = const SizedBox(),
    this.showPlusIcon = false,
    this.title = 'Title Not Provided',
    this.dialogHeight = 450,
    this.plusAction,
    this.doneAction,
    this.showDoneButton = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetState(body, showPlusIcon, title, dialogHeight, plusAction, doneAction, showDoneButton);
  }
}

class _BottomSheetState extends State<BottomSheet>
    with TickerProviderStateMixin {
  final descriptionTextController = TextEditingController();
  final Widget body;
  final bool showPlusIcon;
  final bool showDoneButton;
  final String title;
  final double dialogHeight;
  final Function? plusAction;
  final Function? doneAction;

  _BottomSheetState(
      this.body,
      this.showPlusIcon,
      this.title,
      this.dialogHeight,
      this.plusAction,
      this.doneAction,
      this.showDoneButton
  );

  @override
  Widget build(BuildContext context) => Container(
      height: dialogHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
          color: Color(ColorConstants.getPrimaryWhite())),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          bottom: 16, left: 12, right: 12, top: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: title,
                      ),
                    ),
                    showPlusIcon
                        ? SizedBox(
                            height: 61,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'Add',
                              color: Color(ColorConstants.getBlueDark()),
                              onPressed: () {
                                if (plusAction != null) {
                                  plusAction!();
                                }
                              },
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              body,
            ],
          ),
          showDoneButton
              ? GestureDetector(
                  onTap: () {
                    if (doneAction != null) {
                      doneAction!();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    alignment: Alignment.center,
                    height: 48,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'DONE',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ));
}
