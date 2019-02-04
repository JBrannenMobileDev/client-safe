import 'package:client_safe/models/LeadListItem.dart';
import 'package:client_safe/pages/leads_page/widgets/LeadListWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class LeadsPage extends StatelessWidget{
  final List<LeadListItem> leads;

  LeadsPage(this.leads);

  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
            pinned: false,
            floating: true,
            snap: false,
            forceElevated: true,
            title: Title(
              color: Colors.white,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
//                    new IconButton(
//                      icon: const Icon(Icons.search),
//                      color: Colors.white,
//                      disabledColor: Colors.white,
//                      tooltip: 'Search Clients',
//                    ),
                    Text(
                      "Leads",
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
              new IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(
                      const SnackBar(
                          content: const Text("Under construction")));
                },
              ),
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
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                new ListView.builder(
                  reverse: false,
                  padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  key: _listKey,
                  itemCount: leads.length,
                  itemBuilder: _buildItem,
                ),
              ])),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index){
    return LeadListWidget(leads.elementAt(index));
  }
}

