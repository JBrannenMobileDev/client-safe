import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeGraphCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/MileageExpensesCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/RecurringExpensesCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/SingleExpenseCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/UnpaidInvoicesCard.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class IncomeAndExpensesPage extends StatefulWidget {
  static const String FILTER_TYPE_INCOME = "Income";
  static const String FILTER_TYPE_EXPENSES = "Expenses";

  @override
  State<StatefulWidget> createState() {
    return _IncomeAndExpensesPageState();
  }
}

class _IncomeAndExpensesPageState extends State<IncomeAndExpensesPage> {
  ScrollController scrollController;
  bool dialVisible = true;
  int selectedIndex = 0;
  Map<int, Widget> tabs;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    tabs = <int, Widget>{
      0: Text(IncomeAndExpensesPage.FILTER_TYPE_INCOME, style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'simple',
        fontWeight: FontWeight.w600,
        color: Color(selectedIndex == 0 ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite()),
      ),),
      1: Text(IncomeAndExpensesPage.FILTER_TYPE_EXPENSES, style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'simple',
        fontWeight: FontWeight.w600,
        color: Color(selectedIndex == 1 ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite()),
      ),),
    };
    return StoreConnector<AppState, JobsPageState>(
        converter: (store) => JobsPageState.fromStore(store),
        builder: (BuildContext context, JobsPageState pageState) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(selectedIndex == 0 ? ColorConstants.getBlueLight() : ColorConstants.getPeachLight()),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(
                          color: Color(ColorConstants.getPrimaryWhite()), //change your color here
                        ),
                        brightness: Brightness.light,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        pinned: false,
                        floating: false,
                        forceElevated: false,
                        expandedHeight: 315.0,
                        centerTitle: true,
                        title: Center(
                          child: Text(
                            selectedIndex == 0 ? 'Income' : 'Expenses',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                        actions: <Widget>[

                        ],
                        flexibleSpace: new FlexibleSpaceBar(
                          background: Column(

                            children: <Widget>[
                              SafeArea(
                                child: PreferredSize(
                                  child: Container(
                                    width: 300.0,
                                    margin: EdgeInsets.only(top: 56.0),
                                    child: CupertinoSlidingSegmentedControl<int>(
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      backgroundColor: Colors.transparent,
                                      children: tabs,
                                      onValueChanged: (int filterTypeIndex) {
                                        setState(() {
                                          selectedIndex = filterTypeIndex;
                                        });
                                        pageState.onFilterChanged(filterTypeIndex == 0 ? IncomeAndExpensesPage.FILTER_TYPE_INCOME : IncomeAndExpensesPage.FILTER_TYPE_EXPENSES);
                                      },
                                      groupValue: selectedIndex,
                                    ),
                                  ),
                                  preferredSize: Size.fromHeight(44.0),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 56.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 96.0,
                                      height: 96.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(48.0),
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                      child: Image(
                                        height: 64.0,
                                        width: 64.0,
                                        image: AssetImage("assets/images/job_progress/payment_requested.png"),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(

                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Income',
                                                style: TextStyle(
                                                  fontFamily: 'simple',
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 8.0, top: 2.0),
                                              padding: EdgeInsets.only(bottom: 2.0),
                                              alignment: Alignment.center,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16.0),
                                                border: Border.all(
                                                    width: 1,
                                                  color: Color(ColorConstants.getPrimaryWhite())
                                                ),
                                              ),
                                              child: FlatButton(
                                                onPressed: () {
                                                  DatePicker.showDatePicker(
                                                    context,
                                                    dateFormat:'yyyy',
                                                    onConfirm: (dateTime, intList) {

                                                    }
                                                  );
                                                },
                                                child: Text(
                                                  '2020',
                                                  style: TextStyle(
                                                    fontFamily: 'simple',
                                                    fontSize: 26.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(ColorConstants.getPrimaryWhite()),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            '\$5,250',
                                            style: TextStyle(
                                              fontFamily: 'simple',
                                              fontSize: 52.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants.getPrimaryWhite()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? IncomeGraphCard() : MileageExpensesCard(),
                            pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? UnpaidInvoicesCard() : RecurringExpensesCard(),
                            pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? SizedBox() : SingleExpenseCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                floatingActionButton: SpeedDial(
                  // both default to 16
                  marginRight: 18,
                  marginBottom: 20,
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0, color: Color(ColorConstants.getPrimaryColor())),
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: dialVisible,
                  // If true user is forced to close dial manually
                  // by tapping main button and overlay is not rendered.
                  closeManually: false,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  onOpen: () => print('OPENING DIAL'),
                  onClose: () => print('DIAL CLOSED'),
                  tooltip: 'Speed Dial',
                  heroTag: 'speed-dial-hero-tag',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        height: 116.0,
                        width: 116.0,
                        child: Image.asset('assets/images/icons/invoices_icon_white.png'),
                      ),
                        backgroundColor: Color(ColorConstants.getPrimaryColor()),
                        labelWidget: Container(
                          alignment: Alignment.center,
                          height: 42.0,
                          width: 124.0,
                          decoration: BoxDecoration(
                            boxShadow: ElevationToShadow[4],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          child: Text(
                            'All invoices',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                        onTap: () => print('FIRST CHILD')
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 124.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Text(
                          'New invoice',
                          style: TextStyle(
                            fontFamily: 'simple',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showNewInvoiceDialog(context);
                      },
                    ),
                  ],
                ),
            ),
          ],
        ),
      );
  }
}
