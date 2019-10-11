import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';
import 'package:client_safe/pages/clients_page/widgets/ClientListWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sider_bar/sider_bar.dart';

class ClientsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientsPageState();
  }
}

class _ClientsPageState extends State<ClientsPage> {
  final String alphabet = "ABCDEFGHIGKLMNOPQRSTUVWXYZ";
  ScrollController _controller = ScrollController();
  final Map<int, Widget> genders = const <int, Widget>{
    0: Text("Clients"),
    1: Text("Leads"),
  };
  List<String> alphabetList;

  @override
  void initState() {
    super.initState();

    alphabetList =
        List<String>.generate(alphabet.length, (index) => alphabet[index]);
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientsPageState>(
        converter: (store) => ClientsPageState.fromStore(store),
        builder: (BuildContext context, ClientsPageState pageState) => Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                title: Center(
                  child: Text(
                    pageState.filterType,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: const Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                actions: <Widget>[

                ],
                bottom: PreferredSize(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      width: 250.0,
                      child: CupertinoSegmentedControl<int>(
                        borderColor: Color(ColorConstants.primary),
                        selectedColor: Color(ColorConstants.primary),
                        unselectedColor: Colors.white,
                        children: genders,
                        onValueChanged: (int filterTypeIndex) {
                          pageState.onFilterChanged(
                              filterTypeIndex == 0 ? "Clients" : "Leads");
                        },
                        groupValue:
                        pageState.filterType.contains("Leads") ? 1 : 0,
                      ),
                    ),
                    preferredSize: Size.fromHeight(44.0),
                ),
              ),
            ],
          ),

//              new AppBar(
//                title: new Text(pageState.filterType),
//                flexibleSpace: Container(
//                  margin: EdgeInsets.only(top: 44.0, bottom: 24.0),
//                  height: 300.0,
//                  width: 185.0,
//                  child: CupertinoSegmentedControl<int>(
//                    borderColor: Colors.white,
//                    selectedColor: Colors.white,
//                    unselectedColor: Color(ColorConstants.primary),
//                    children: genders,
//                    onValueChanged: (int filterTypeIndex) {
//                      pageState.onFilterChanged(
//                          filterTypeIndex == 0 ? "Clients" : "Leads");
//                    },
//                    groupValue: pageState.filterType.contains("Leads") ? 1 : 0,
//                  ),
//                ),
//              ),
//              body: Stack(
//                alignment: AlignmentDirectional.centerEnd,
//                children: <Widget>[
//                  ListView.builder(
//                    controller: _controller,
//                    itemCount: pageState.filterType.contains("Leads")
//                        ? pageState.leads.length
//                        : pageState.clients.length,
//                    itemBuilder: _buildItem,
//                  ),
//                  SideBar(
//                      list: alphabetList,
//                      textColor: Color(ColorConstants.primary),
//                      color: Color(ColorConstants.primary).withOpacity(0.2),
//                      valueChanged: (value) {
//                        _controller
//                            .jumpTo(alphabetList.indexOf(value) * 44.0);
//                      })
//                ],
        ),
      );
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, ClientsPageState>(
    converter: (store) => ClientsPageState.fromStore(store),
    builder: (BuildContext context, ClientsPageState pageState) =>
        ClientListWidget(index),
  );
}
