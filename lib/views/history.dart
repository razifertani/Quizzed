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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.resultat.quizId),
        Text(widget.resultat.quizTitle),
        Text(widget.resultat.quizResult),
        Card(
          color: Colors.grey[800],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.resultat.quizTitle,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      widget.resultat.quizTitle,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
