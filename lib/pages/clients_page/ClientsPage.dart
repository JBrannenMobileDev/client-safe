import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/clients_page/widgets/ClientListWidget.dart';
import 'package:client_safe/pages/clients_page/widgets/ClientSearchButtons.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class ClientsPage extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  ClientsPage({this.clients});
  final List<Client> clients;

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(ColorConstants.primary_light),
        image: DecorationImage(
          image: AssetImage('assets/images/cameras_background.jpg'),
          repeat: ImageRepeat.repeat,
          colorFilter: new ColorFilter.mode(
              Colors.white.withOpacity(0.05), BlendMode.dstATop),
          fit: BoxFit.contain,
        ),
      ),
      child: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            backgroundColor: const Color(ColorConstants.primary),
            pinned: true,
            floating: true,
            snap: false,
            forceElevated: true,
            expandedHeight: 200.0,
            title: Title(
              color: Colors.white,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      disabledColor: Colors.white,
                      tooltip: 'Search Clients',
                    ),
                    Text(
                      "Search Clients",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 0.0),
                child: Text(
                  "Filter",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: new FlexibleSpaceBar(
              background: Stack(
                children: <Widget>[ClientSearchButtons()],
              ),
            ),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                new ListView.builder(
                  reverse: true,
                  padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  key: _listKey,
                  itemCount: clients.length,
                  itemBuilder: _buildItem,
                ),
          ])),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return ClientListWidget(name: clients.elementAt(index).name, date: clients.elementAt(index).dateLastContacted,);
  }
}
