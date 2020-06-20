import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeableCardsWidget extends StatefulWidget {
  final double width;

  SwipeableCardsWidget(this.width);

  @override
  State<StatefulWidget> createState() {
    return _SwipeableCardsWidgetState(width - 22);
  }
  
}

class _SwipeableCardsWidgetState extends State<SwipeableCardsWidget> with TickerProviderStateMixin {
  List<Widget> cardList;
  final double width;

  _SwipeableCardsWidgetState(this.width);

  @override
  void initState() {
    cardList = _getMatchCard();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ...cardList,
      ],
    );
  }

  List<Widget> _getMatchCard() {
    int numOfCards = 4;
    List<MatchCard> cards = new List();
    cards.add(MatchCard(Color(ColorConstants.getPrimaryWhite()), 5));
    cards.add(MatchCard(Color(ColorConstants.getPrimaryWhite()), 10));
    cards.add(MatchCard(Color(ColorConstants.getPrimaryWhite()), 15));
    cards.add(MatchCard(Color(ColorConstants.getPrimaryWhite()), 20));

    List<Widget> cardList = new List();
    for (int x = 0; x < numOfCards; x++) {
      cardList.add(Positioned(
        top: cards[x].margin,
        child: Draggable(
          onDragEnd: (drag){
            _removeCard(x);
          },
          childWhenDragging: Container(),
          feedback: Container(
            alignment: Alignment.center,
            width: width - ((numOfCards-x)*4),
            child: Card(
              color: cards[x].color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                alignment: Alignment.center,
                height: 78,
                child: FlatButton(
                  onPressed: () {

                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 8.0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 18.0, top: 4.0),
                              height: 38.0,
                              width: 38.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(ImageUtil.collectionIcons.elementAt(2)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(

                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                                        child: Text(
                                          'Overdue Invoice',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'simple',
                                            fontWeight: FontWeight.w800,
                                            color: Color(ColorConstants.getPeachDark()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Brannen family shot - \$350',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w400,
                                      color: Color(ColorConstants.getPeachDark()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Icon(
                            Icons.chevron_right,
                            color: Color(ColorConstants.primary_bg_grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            width: width - ((numOfCards-x)*4),
            child: Card(
              elevation: 2.0,
              color: cards[x].color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                alignment: Alignment.center,
                height: 78,
                child: FlatButton(
                  onPressed: () {

                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 8.0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 18.0, top: 4.0),
                              height: 38.0,
                              width: 38.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/icons/reminder_icon_peach.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(

                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                                        child: Text(
                                          'Overdue Invoice',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'simple',
                                            fontWeight: FontWeight.w800,
                                            color: Color(ColorConstants.getPeachDark()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Brannen family shot - \$350',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w400,
                                      color: Color(ColorConstants.getPeachDark()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Icon(
                            Icons.chevron_right,
                            color: Color(ColorConstants.primary_bg_grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
      );
    }
    return cardList;
  }

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    }
    );
  }
}

class MatchCard {
  Color color;
  double margin = 0;
  MatchCard(Color color, double marginTop) {
    this.color = color;
    margin = marginTop;
  }
}