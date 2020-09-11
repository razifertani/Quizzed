import 'dart:async';

import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final String userUID;
  History({Key key, this.userUID}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  QuerySnapshot quizSnapshot;
  DataBaseService databaseService = new DataBaseService();
  String quizId, quizTitle, quizResault;
  bool isLoading = true;

  @override
  void initState() {
    databaseService.getUserHistory(widget.userUID).then((value) {
      setState(() {
        quizSnapshot = value;
      });
    });
    super.initState();
  }

  ResultModel getResultModelFromDatasnapshot(DocumentSnapshot quizSnapshot) {
    ResultModel resaultModel = new ResultModel();

    resaultModel.quizId = quizSnapshot.data["quizzId"];
    resaultModel.quizTitle = quizSnapshot.data["quizzTitle"];
    resaultModel.quizResult = quizSnapshot.data["quizzResult"];
    resaultModel.imageURL = quizSnapshot.data["quizzImage"];
    resaultModel.passed = quizSnapshot.data["quizzPassed"];

    return resaultModel;
  }

  waiting() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: isLoading
          ? waiting()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    quizSnapshot.documents.length == 0
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                'No historic !',
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: quizSnapshot.documents.length,
                            itemBuilder: (context, index) {
                              return ResultTile(
                                resultat: getResultModelFromDatasnapshot(
                                  quizSnapshot.documents[index],
                                ),
                                index: index,
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: buildConvexAppBar(context, 2, widget.userUID),
    );
  }
}

class ResultModel {
  String quizId;
  String quizTitle;
  String quizResult;
  String imageURL;
  bool passed;
}

class ResultTile extends StatefulWidget {
  final ResultModel resultat;
  final int index;
  ResultTile({Key key, this.resultat, this.index}) : super(key: key);

  @override
  _ResultTileState createState() => _ResultTileState();
}

class _ResultTileState extends State<ResultTile> {
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 200),
      () {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(widget.resultat.quizId),
        // Text(widget.resultat.quizTitle),
        // Text(widget.resultat.quizResult),
        // Text(widget.resultat.imageURL),
        // Text(widget.resultat.passed == true ? 'Njah' : 'Fages'),

        Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
            color: widget.resultat.passed == true
                ? Colors.green[600]
                : Colors.red[700],
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.resultat.imageURL,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.resultat.quizTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Text(
                          '${widget.resultat.quizResult} %',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 45,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
