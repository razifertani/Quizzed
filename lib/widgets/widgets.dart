import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/views/history.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/views/profile.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  // return RichText(
  //   text: TextSpan(
  //     style: TextStyle(fontSize: 28),
  //     children: <TextSpan>[
  //       TextSpan(
  //         text: 'Quiz',
  //         style: TextStyle(
  //           fontFamily: 'Airbnb',
  //           fontWeight: FontWeight.w600,
  //           color: Colors.black54,
  //         ),
  //       ),
  //       TextSpan(
  //         text: 'Game',
  //         style: TextStyle(
  //           fontFamily: 'Airbnb',
  //           fontWeight: FontWeight.w600,
  //           color: Colors.blue,
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  return Image.asset(
    'Assets/appBar.png',
  );
}

Widget blueButton(BuildContext context, String label, double width) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: 18,
    ),
    height: MediaQuery.of(context).size.height * 0.08,
    width: width,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(
        30,
      ),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 19,
      ),
    ),
  );
}

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  const OptionTile(
      {@required this.option,
      @required this.description,
      @required this.correctAnswer,
      @required this.optionSelected});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.optionSelected == widget.description
                      ? widget.description == widget.correctAnswer
                          ? Colors.green
                          : Colors.red
                      : Colors.grey,
                  width: 1.8),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.option,
              style: TextStyle(
                color: widget.optionSelected == widget.description
                    ? widget.description == widget.correctAnswer
                        ? Colors.green
                        : Colors.red
                    : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 17,
              color: widget.optionSelected == widget.description
                  ? widget.description == widget.correctAnswer
                      ? Colors.green
                      : Colors.red
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

ConvexAppBar buildConvexAppBar(
    BuildContext context, int index, String userUID, String lang) {
  return ConvexAppBar(
    backgroundColor: Colors.blue,
    height: MediaQuery.of(context).size.height * 0.07,
    items: [
      TabItem(
        icon: Icons.people,
        title: AppLocalizations.of(context).translate('Widgets/first'),
      ),
      TabItem(
        icon: Icons.home,
        title: AppLocalizations.of(context).translate('Widgets/second'),
      ),
      TabItem(
        icon: Icons.history,
        title: AppLocalizations.of(context).translate('Widgets/third'),
      ),
    ],
    initialActiveIndex: index,
    onTap: (int i) {
      i == 0
          ? index == 0
              ? null
              : Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return new Profile(
                        userUID: userUID,
                        lang: lang,
                      );
                    },
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return new FadeTransition(
                          opacity: animation, child: child);
                    },
                  ),
                )
          : null;
      i == 1
          ? index == 1
              ? null
              : Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return new Home(
                        userUID: userUID,
                        lang: lang,
                      );
                    },
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return new FadeTransition(
                          opacity: animation, child: child);
                    },
                  ),
                )
          : null;
      i == 2
          ? index == 2
              ? null
              : Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return History(
                        userUID: userUID,
                        lang: lang,
                      );
                    },
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return new FadeTransition(
                          opacity: animation, child: child);
                    },
                  ),
                )
          : null;
    },
  );
}
