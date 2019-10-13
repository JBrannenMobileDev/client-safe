import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';
import 'package:client_safe/pages/clients_page/widgets/ClientListWidget.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sider_bar/sider_bar.dart';

class ClientsPage extends StatefulWidget {
  static const String FILTER_TYPE_CLIENTS = "Clients";
  static const String FILTER_TYPE_LEADS = "Leads";
  static const String FILTER_TYPE_ALL = "All";

  @override
  State<StatefulWidget> createState() {
    return _ClientsPageState();
  }
}

class _ClientsPageState extends State<ClientsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final String alphabet = "ABCDEFGHIGKLMNOPQRSTUVWXYZ";
  ScrollController _controller = ScrollController();
  final Map<int, Widget> genders = const <int, Widget>{
    0: Text(ClientsPage.FILTER_TYPE_ALL),
    1: Text(ClientsPage.FILTER_TYPE_CLIENTS),
    2: Text(ClientsPage.FILTER_TYPE_LEADS),
  };
  List<String> alphabetList;

  @override
  void initState() {
    super.initState();
    alphabetList = List<String>.generate(alphabet.length, (index) => alphabet[index]);
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientsPageState>(
        onInit: (store) => store.dispatch(FetchClientData(store.state.clientsPageState)),
        converter: (store) => ClientsPageState.fromStore(store),
        builder: (BuildContext context, ClientsPageState pageState) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.white,
                        pinned: true,
                        centerTitle: true,
                        title: Center(
                          child: Text(
                            pageState.filterType + " Contacts",
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: const Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Color(ColorConstants.primary),
                            tooltip: 'Add',
                            onPressed: () {
                              UserOptionsUtil.showNewContactDialog(context);
                            },
                          ),
                        ],
                        bottom: PreferredSize(
                          child: Container(
                            width: 300.0,
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSegmentedControl<int>(
                              borderColor: Color(ColorConstants.primary),
                              selectedColor: Color(ColorConstants.primary),
                              unselectedColor: Colors.white,
                              children: genders,
                              onValueChanged: (int filterTypeIndex) {
                                pageState.onFilterChanged(
                                    filterTypeIndex == 0
                                        ? ClientsPage.FILTER_TYPE_ALL : filterTypeIndex == 1
                                        ? ClientsPage.FILTER_TYPE_CLIENTS : ClientsPage.FILTER_TYPE_LEADS);
                              },
                              groupValue: pageState.filterType == ClientsPage.FILTER_TYPE_ALL ? 0 : pageState.filterType == ClientsPage.FILTER_TYPE_CLIENTS ? 1 : 2,
                            ),
                          ),
                          preferredSize: Size.fromHeight(44.0),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            ListView.builder(
                              reverse: false,
                              padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: pageState.filterType == ClientsPage.FILTER_TYPE_ALL
                                  ? pageState.all.length : pageState.filterType == ClientsPage.FILTER_TYPE_CLIENTS
                                  ? pageState.clients.length : pageState.leads.length,
                              itemBuilder: _buildItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SideBar(
                      list: alphabetList,
                      textColor: Color(ColorConstants.primary),
                      color: Color(ColorConstants.primary).withOpacity(0.2),
                      valueChanged: (value) {
                        _controller.jumpTo(alphabetList.indexOf(value) * 44.0);
                      })
                ],
          ),
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
