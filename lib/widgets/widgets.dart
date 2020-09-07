import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return Center(
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 28),
        children: <TextSpan>[
          TextSpan(
            text: 'Quizzed',
            style: TextStyle(
              fontFamily: 'Airbnb',
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          TextSpan(
            text: 'Game',
            style: TextStyle(
              fontFamily: 'Airbnb',
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget blueButton(BuildContext context, String label, double width) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16),
    height: MediaQuery.of(context).size.height * 0.08,
    width: width,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.blue, borderRadius: BorderRadius.circular(30)),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}

showMaterialDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => new AlertDialog(
      title: Center(
        child: new Text(
          "Error",
          style: TextStyle(color: Colors.red, fontSize: 25),
        ),
      ),
      content: new Text(
        "Incorrect Email/Password !",
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
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
