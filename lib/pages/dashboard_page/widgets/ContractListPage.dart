import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/ContractsItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';

class ContractListPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  ContractListPage({Key? key,
    this.pageState,
    this.signed
  }) : super(key: key);

  final DashboardPageState? pageState;
  final bool? signed;

  @override
  Widget build(BuildContext context)=> StoreConnector<AppState, DashboardPageState>(
      converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
      builder: (BuildContext context, DashboardPageState pageState) => Scaffold(
      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
      body: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                pinned: true,
                floating: false,
                forceElevated: false,
                centerTitle: true,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: signed! ? 'All Signed Contracts' : 'All Unsigned Contracts',
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  color: Color(ColorConstants.getPrimaryColor()),
                  tooltip: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ), systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    ListView.builder(
                      reverse: false,
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: const ClampingScrollPhysics(),
                      key: _listKey,
                      itemCount: signed! ? pageState.allSignedContracts!.length : pageState.allUnsignedContracts!.length,
                      itemBuilder: _buildItem,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );


  Widget _buildItem(BuildContext context, int index) {
    return ContractsItem(contract: signed! ? pageState!.allSignedContracts!.elementAt(index) : pageState!.allUnsignedContracts!.elementAt(index), pageState: pageState!);
  }

}